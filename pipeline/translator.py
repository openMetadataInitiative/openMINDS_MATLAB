"""
Generates openMINDS MATLAB classes.
"""

import glob
import json
import math
import os
import re
from typing import List
from collections import defaultdict
import warnings

from jinja2 import Environment

from pipeline.constants import (
    OPENMINDS_VOCAB_URI,
    SCHEMA_PROPERTY_TYPE,
    SCHEMA_PROPERTY_LINKED_TYPES,
    SCHEMA_PROPERTY_EMBEDDED_TYPES )

from pipeline.utils import camel_case, InstanceLoader

type_name_map = {
    "string": "string",
    "integer": "int64",
    "number": "double",
    "array": "list"
}

format_map = {
    "iri": "string",
    "date": "datetime",
    "date-time": "datetime",
    "time": "datetime",
    "email": "string",
    "ECMA262": "string"
}

OUTPUT_FILE_FORMAT = "m"
TEMPLATE_FILE_NAME = "matlab_schema_class_template.txt"
TEMPLATE_FILE_NAME_CT = "matlab_controlledterm_class_template.txt"


class MATLABSchemaBuilder(object):
    """ Class for building MATLAB schema classes """

    def __init__(self, schema_file_path:str, root_path:str, jinja_template_environment:Environment):
        
        self._parse_source_file_path(schema_file_path, root_path)

        with open(schema_file_path, "r") as schema_file:
            self._schema_payload = json.load(schema_file)
        
        if self._schema_model_name == "controlledTerms":
            template_file_name = TEMPLATE_FILE_NAME_CT
        else:
            template_file_name = TEMPLATE_FILE_NAME

        self.schema_template = jinja_template_environment.get_template(template_file_name)

    def build(self):
        """Build and save the MATLAB schema class file"""
        target_file_path = self._create_target_file_path()
        os.makedirs(os.path.dirname(target_file_path), exist_ok=True)

        schema_classdef_str = self.translate()

        with open(target_file_path, "w", encoding="utf-8") as target_file:
            target_file.write(schema_classdef_str)

    def translate(self):
        """Translate the openMINDS schema into a MATLAB class definition"""
        self._extract_template_variables() # Preprocess schema?

        self._generate_additional_files()
        
        schema_classdef_str = self._expand_schema_template()
        return schema_classdef_str

    def _parse_source_file_path(self, schema_file_path:str, root_path:str):
        _relative_path_without_extension = schema_file_path[len(root_path)+1:].replace(".schema.omi.json", "").split("/")
        self.version = _relative_path_without_extension[0]
        self._schema_model_name = _relative_path_without_extension[1]
        if len(_relative_path_without_extension) == 3:
            self._schema_group_name = []
        else:
            schema_group_name = _relative_path_without_extension[2]
            # Remove all non alphanumeric characters
            self._schema_group_name = re.sub(r'\W+', '', schema_group_name)

        self._schema_file_name = _relative_path_without_extension[-1]

    def _create_target_file_path(self) -> str:
        target_root_path = os.path.join("target", "schemas", self.version)
        if self._schema_group_name:
            matlab_package_directory = os.path.join("+openminds", f"+{self._schema_model_name}".lower(), f"+{self._schema_group_name}".lower())
        else:
            matlab_package_directory = os.path.join("+openminds", f"+{self._schema_model_name}".lower())
        matlab_class_file_name = f"{self._schema_file_name}.{OUTPUT_FILE_FORMAT}"
        matlab_class_file_name = matlab_class_file_name[0].upper() + matlab_class_file_name[1:]

        return os.path.join(target_root_path, matlab_package_directory, matlab_class_file_name)

    def _extract_template_variables(self):
        """Extract variables from the schema that are needed for the template"""

        schema = self._schema_payload

        # Todo: Create method for getting name with right casing...
        schema_short_name = os.path.basename(schema[SCHEMA_PROPERTY_TYPE])
        
        props = [] # List of template property attributes (shortened name to avoid very long lines)

        for full_name, property_info in sorted(schema["properties"].items(), key=_property_name_sort_key):
            
            property_name = _create_matlab_name(full_name)

            allow_multiple = property_info.get("type") == "array"
            has_linked_type = SCHEMA_PROPERTY_LINKED_TYPES in property_info
            has_embedded_type = SCHEMA_PROPERTY_EMBEDDED_TYPES in property_info

            # Resolve property class name in matlab
            if has_linked_type:
                possible_types = [
                    f'{_generate_class_name(iri)}'
                    for iri in property_info[SCHEMA_PROPERTY_LINKED_TYPES]
                ]
            elif has_embedded_type:
                possible_types = [
                    f'{_generate_class_name(iri)}'
                    for iri in property_info[SCHEMA_PROPERTY_EMBEDDED_TYPES]
                ]  # todo: handle minItems maxItems, e.g. for axesOrigin
            elif "_formats" in property_info:
                assert property_info["type"] == "string"
                possible_types = sorted(set([format_map[item] for item in property_info["_formats"]]))
            elif property_info.get("type") == "array":
                possible_types = [type_name_map[property_info["items"]["type"]]]
            else:
                possible_types = [type_name_map[property_info["type"]]]

            # Resolve property dimension in matlab
            if allow_multiple:
                size_attribute = "(1,:)"
            else:
                size_attribute = "(1,1)"
            size_attribute_doc = size_attribute

            # To work around not allowing empty scalars in matlab, the 
            # actual size of of scalars is set to a list (Validators will
            # ensure that only scalars are allowed)
            if property_info.get("type") == 'integer':
                size_attribute = "(1,:)"

            # ...ditto for date-time formats
            if _is_datetime_format(property_info):
                size_attribute = "(1,:)"

            # ...and for linked/embedded types
            if has_linked_type or has_embedded_type:
                size_attribute = "(1,:)"
                possible_types_docstr = [_create_matlab_help_link(type_str) for type_str in possible_types]
            else:
                possible_types_docstr = possible_types

            # Resolve property validators in matlab
            validators = _create_property_validator_functions(property_name, property_info)

            if len(possible_types) == 1:
                possible_types = possible_types[0]
                possible_types_str = f'"{possible_types}"'
                possible_types_docstr = possible_types_docstr[0]
            else:
                possible_types_str = _list_to_string_array(possible_types, do_sort=True)
                possible_types_docstr = ", ".join(sorted(possible_types_docstr))
 
                class_name = _generate_class_name(schema[SCHEMA_PROPERTY_TYPE]).split(".")[-1]
                possible_types = _create_mixedtype_full_class_name(class_name, property_name)

            template_property_attributes = {
                "name": property_name,
                "type": possible_types,
                "type_doc": possible_types_docstr,
                "type_list": possible_types_str,
                "size": size_attribute,
                "size_doc": size_attribute_doc,
                "validators": "{{{}}}".format(', '.join(validators)) if validators else "",
                "allow_multiple": allow_multiple,
                "required": full_name in schema.get("required", []),
                "is_linked": SCHEMA_PROPERTY_LINKED_TYPES in property_info,
                "is_embedded": SCHEMA_PROPERTY_EMBEDDED_TYPES in property_info,
                "doc": _generate_property_doc(property_info, schema_short_name)
            }
            props.append(template_property_attributes)

        max_property_name_length = max([len(prop["name"]) for prop in props])
        
        linked_types = [ {'name':prop["name"],'types':prop["type_list"]} for prop in props if prop["is_linked"] ]
        embedded_types = [ {'name':prop["name"],'types':prop["type_list"]} for prop in props if prop["is_embedded"] ]

        class_name = _generate_class_name(schema[SCHEMA_PROPERTY_TYPE]).split(".")[-1]
        display_label_method_expression = _get_display_label_method_expression(class_name)

        # TODO: Specify base class. Implement template with configurable base class. Schema or ControlledTerm?
        # Or; just remove this as it's not needed when using separate templates.
        if self._schema_model_name == "controlledTerms":
            base_class = "openminds.abstract.ControlledTerm"
        else:
            base_class = "openminds.abstract.Schema"

        if self._schema_model_name == "controlledTerms":
            instance_loader = InstanceLoader()
            known_instance_list = instance_loader.get_instance_collection(self.version, class_name)
            known_instance_list.sort()
        else:
            known_instance_list = []

        self._template_variables = {
            "class_name": class_name,
            "base_class": base_class,
            "openminds_type": schema[SCHEMA_PROPERTY_TYPE],
            "docstring": schema.get("description", "No description available."),
            "props": props,
            "max_property_name_length": max_property_name_length,
            "required_properties": [f'{prop["name"]}' for prop in props if prop["required"]],
            "linked_types": linked_types,
            "embedded_types": embedded_types,
            "display_label_method_expression": display_label_method_expression,
            "known_instance_list": known_instance_list,
        }
        
    def _expand_schema_template(self) -> str:
        # print(f"Expanding template for {self._schema_file_name}")

        template_variables = self._template_variables
        result = self.schema_template.render(template_variables)
        return _strip_trailing_whitespace(result)

    def _generate_additional_files(self):
        """
        Create mixedtype classes for linked/embedded types with multiple possible types
        """

        # Create mixedtype class 
        for prop in self._template_variables["props"]:
            if prop["is_linked"] or prop["is_embedded"]:
                if len(prop["type_list"]) > 1:
                    self._build_mixed_type_class(self._template_variables, prop)

    def _build_mixed_type_class(self, schema, prop):

        # Build package directory path and create directory if necessary
        package_name_list = _get_mixedtype_package_name_list(schema["class_name"])
        package_parts = ["+" + name for name in package_name_list]
        path_parts = ["target", "mixedtypes", self.version] + package_parts
        os.makedirs(os.path.join(*path_parts), exist_ok=True)

        # Make first letter of property name uppercase
        property_name = prop["name"]
        property_name = property_name[0].upper() + property_name[1:]

        # Add file extension and build file path
        file_name = property_name + ".m"
        file_path = os.path.join(*path_parts, file_name)

        # Write file content # Todo: use a template
        with open(file_path, "w") as fp:
            fp.write(f"classdef {property_name} < openminds.internal.abstract.LinkedCategory\n")
            fp.write(f"    properties (Constant, Hidden)\n")
            fp.write(f"        ALLOWED_TYPES = {prop['type_list']}\n")
            fp.write(f"        IS_SCALAR = {str(not(prop['allow_multiple'])).lower()}\n")
            fp.write(f"    end\n")
            fp.write(f"end\n")


# # # LOCAL UTILITY FUNCTIONS # # #

def _create_matlab_name(json_name):
    """Remove the openMINDS prefix from a name"""
    return json_name.replace(OPENMINDS_VOCAB_URI, '')

def _generate_class_name(iri):
    """
    Generate a class name from an IRI. 
    E.g https://openminds.ebrains.eu/core/Subject -> openminds.core.Subject
    """
    parts = iri.split("/")[-2:]
    for i in range(len(parts) - 1):
        parts[i] = parts[i].lower()
    return "openminds." + ".".join(parts)

def _to_label(class_name_list):
    # split on . and keep last
    return [class_name.split(".")[-1] for class_name in class_name_list]
    
def _get_schema_display_label(schema_short_name):
    """
    Make a label for a schema from its name
    
    Examples: 
        DOI -> DOI
        Subject -> subject
        TissueSample -> tissue sample
    """
    if schema_short_name.upper() == schema_short_name:  # for acronyms, e.g. DOI
        schema_name_label = schema_short_name
    else:
        #Replace each capital letter with a space and the capital letter
        schema_name_label = re.sub("([A-Z])", " \g<0>", schema_short_name).strip().lower()

    return schema_name_label

def _get_mixedtype_package_name_list(schema_name):
    return ["openminds", "internal", "mixedtype", schema_name.lower()]

def _create_mixedtype_full_class_name(schema_name, property_name):
    """
    Create full class name (including package) for mixed type
    """        
    property_name = _create_matlab_name(property_name)
    property_name = property_name[0].upper() + property_name[1:]
    parts = _get_mixedtype_package_name_list(schema_name) + [property_name]
    return ".".join(parts)

def _generate_property_doc(property_info, schema_short_name):
    """Generate a docstring for a property"""

    schema_display_label = _get_schema_display_label(schema_short_name)
    
    doc = property_info.get("_instruction", "no description available")
    doc = doc.replace("someone or something", f"the {schema_display_label}")
    doc = doc.replace("something or somebody", f"the {schema_display_label}")
    doc = doc.replace("something or someone", f"the {schema_display_label}")
    doc = doc.replace("a being or thing", f"the {schema_display_label}")
    return doc

def _property_name_sort_key(arg):
    """Sort the name property to be first"""
    name, property_info = arg
    priorities = {
        "name": "0",
        "fullName": "1",
        "shortName": "2",
        "lookupLabel": "3",
    }
    return priorities.get(name, name)

def _strip_trailing_whitespace(s):
    return "\n".join([line.rstrip() for line in s.splitlines()])

def _is_datetime_format(property_info):
    return property_info.get("type") == 'string' \
            and  property_info.get("_formats") \
                and any(item in ["date",  "date-time", "time"] for item in property_info.get("_formats"))

# # # LOCAL MATLAB SPECIFIC UTILITY FUNCTIONS # # #

def _create_matlab_help_link(schema_class_name):
    
    label = schema_class_name.split(".")[-1]
    schema_help_link = f'<a href="matlab:help {schema_class_name}" style="font-weight:bold">{label}</a>'

    return schema_help_link

def _list_to_string_array(list_of_strings, do_sort=False):

    # Add quotes to strings in list to make them strings when added to template
    list_of_strings = [f'"{type_name}"' for type_name in list_of_strings]

    if do_sort:
        list_of_strings = sorted(list_of_strings)

    string_array = "[{}]".format(", ".join(list_of_strings))
    return string_array

def _get_display_label_method_expression(schema_short_name):
    """
        Create the display label expression to be added as a getDisplayLabel 
        method in the schema class
    """

    display_config_filepath = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'instanceDisplayConfig.json')
    #display_config_filepath = 'instanceDisplayConfig.json'

    # Todo: The json keys should match the schema name exactly, i.e capitalized

    with open(display_config_filepath, 'r') as f:
        config_json = json.load(f)

    is_camel_case_match = camel_case(schema_short_name) in config_json.keys()
    is_upper_case_match = schema_short_name.upper() in config_json.keys()  # Some schemas like DOI etc. are all uppercase
    
    if is_camel_case_match or is_upper_case_match:

        if is_camel_case_match:
            schema_filename = camel_case(schema_short_name)
        elif is_upper_case_match:
            schema_filename = schema_short_name.upper()

        this_config = config_json[schema_filename]

        prop_names = this_config['propertyName']
        str_formatter = this_config['stringFormat']

        if not prop_names:
            return ""

        if not isinstance(prop_names, list):
            prop_names = [prop_names]

        if not isinstance(str_formatter, list):
            str_formatter = [str_formatter]

        for i in range(len(prop_names)):
            str_formatter = [sf.replace(prop_names[i], f"obj.{prop_names[i]}") for sf in str_formatter]

        for i, this_line in enumerate(str_formatter):
            if 'sprintf' in this_line:
                this_line = this_line.replace('sprintf', 'str = sprintf')
                this_line = f"{this_line};"
                str_formatter[i] = this_line
        # Join the lines with newline 
        return '\n            '.join(str_formatter)
    else:
        return ""

def _create_property_validator_functions(name, property_info):

    property_name = name
    allow_multiple = property_info.get("type") == "array"
    has_linked_type = SCHEMA_PROPERTY_LINKED_TYPES in property_info
    has_embedded_type = SCHEMA_PROPERTY_EMBEDDED_TYPES in property_info

    validation_functions = []

    if property_info.get("type") == 'integer':
        validation_functions += [f'mustBeSpecifiedLength({property_name}, 0, 1)']

    if _is_datetime_format(property_info):
        validation_functions += [f'mustBeSpecifiedLength({property_name}, 0, 1)']

        if "date" in property_info.get("_formats"):
            validation_functions += [f"mustBeValidDate({property_name})"]
        elif "time" in property_info.get("_formats") == "time":
            validation_functions += [f"mustBeValidTime({property_name})"]

    if has_linked_type or has_embedded_type:
        if not allow_multiple:
            validation_functions += [f'mustBeSpecifiedLength({property_name}, 0, 1)']

    if 'maxItems' in property_info:
        if 'minItems' in property_info:
            min_items = property_info['minItems']
            # Uncomment the following lines if needed
            # if 'required' in obj.Schema and name not in obj.Schema['required']:
            #     min_items = 0
        else:
            min_items = 0

        max_items = property_info['maxItems']
        validation_functions += [f"mustBeSpecifiedLength({name}, {min_items}, {max_items})"]

    elif 'uniqueItems' in property_info:
        validation_functions += [f"mustBeListOfUniqueItems({name})"]

    elif 'minLength' in property_info or 'maxLength' in property_info:
        min_length = property_info.get('minLength', 0)
        max_length = property_info.get('maxLength', float('inf'))
        validation_functions += [f"mustBeValidStringLength({name}, {min_length}, {max_length})"]

    elif 'pattern' in property_info:
        if 'archive.softwareheritage' in property_info['pattern']:
            print("SWHID str pattern validation is hard-coded")
            escaped_str_pattern = r"^https://archive.softwareheritage.org/swh:1:(cnt|dir|rel|rev|snp):[0-9a-f]{40}(;(origin|visit|anchor|path|lines)=[^ \t\r\n\f]+)*$"
        else:
            escaped_str_pattern = property_info['pattern']

        validation_functions += [f"mustMatchPattern({name}, '{escaped_str_pattern}')"]

    elif 'minimum' in property_info or 'maximum' in property_info:
        min_value = property_info.get('minimum', float('nan'))
        max_value = property_info.get('maximum', float('nan'))

        validation_functions += [f"mustBeInteger({name})"]

        if not math.isnan(min_value) and not math.isnan(max_value):
            validation_functions += [f"mustBeInRange({name}, {min_value}, {max_value})"]
        elif math.isnan(min_value):
            validation_functions += [f"mustBeLessThanOrEqual({name}, {max_value})"]
        elif math.isnan(max_value):
            validation_functions += [f"mustBeGreaterThanOrEqual({name}, {min_value})"]

    return validation_functions


if __name__ == "__main__":
    error('Not implemented yet')
