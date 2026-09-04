"""
Generates openMINDS MATLAB classes.
"""

import glob
import json
import os
import re
from typing import List, Dict
from collections import Counter

from jinja2 import Template

from pipeline.constants import (
    OPENMINDS_BASE_URI,
    SCHEMA_PROPERTY_TYPE,
    SCHEMA_PROPERTY_LINKED_TYPES,
    SCHEMA_PROPERTY_EMBEDDED_TYPES )

from pipeline.utils import (
    camel_case,
    namespace_name,
    parse_schema_file_path,
    InstanceLoader,
    SCHEMA_FILE_EXTENSION )

types_with_controlled_instances = [
    "BrainAtlasVersion",
    "BrainAtlas",
    "CommonCoordinateSpaceVersion",
    "CommonCoordinateSpace",
    "ContentType",
    "License",
    "ParcellationEntity",
    "ParcellationEntityVersion"
]

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

PROPERTY_NAME_OVERRIDES = {
    # MATLAB identifier override for openMINDS property names that are not
    # valid MATLAB property names.
    "z-stepSize": "zStepSize",
}

OUTPUT_FILE_FORMAT = "m"


class MATLABSchemaBuilder(object):
    """ Class for building MATLAB schema classes """

    def __init__(self, schema_file_path:str, root_path:str, class_name_map:Dict[str, str], jinja_templates:Dict[str, Template]):
        
        self._schema_root_path = root_path
        self._parse_source_file_path(schema_file_path, root_path)
        self._class_name_map = class_name_map

        with open(schema_file_path, "r", encoding="utf-8") as schema_file:
            self._schema_payload = json.load(schema_file)
        
        if self._schema_module_name == "controlledTerms":
            self.class_template = jinja_templates["controlledterm_class"]
        else:
            self.class_template = jinja_templates["schema_class"]

        self.mixedtype_class_template = jinja_templates["mixedtype_class"]

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

    def get_property_definitions(self):
        """Return the template property attributes for this schema's properties.

        Exposes the rendered property definitions without writing any file, so
        that a class assembled from a subset of them, such as the controlled
        term base class, is rendered exactly like the generated classes.
        """
        self._extract_template_variables()
        return self._template_variables["props"]

    def _parse_source_file_path(self, schema_file_path:str, root_path:str):
        schema_info = parse_schema_file_path(schema_file_path, root_path)

        self.version = schema_info["version"]
        self._schema_module_name = schema_info["module_name"]
        self._schema_group_name = schema_info["group_name"]
        # The file name keeps the case of the path, because the instances of a
        # controlled term are stored in a folder of the same name
        self._schema_file_name = schema_info["file_name"]
        self._schema_class_name = schema_info["type_name"]

    def _create_target_file_path(self) -> str:
        package_parts = ["+openminds", f"+{namespace_name(self._schema_module_name)}"]
        if self._schema_group_name:
            package_parts.append(f"+{namespace_name(self._schema_group_name)}")

        matlab_class_file_name = f"{self._schema_class_name}.{OUTPUT_FILE_FORMAT}"

        return os.path.join(
            "target", "types", self.version, *package_parts, matlab_class_file_name
        )

    def _extract_template_variables(self):
        """Extract variables from the schema that are needed for the template"""

        schema = self._schema_payload

        schema_short_name = _parse_schema_type( schema[SCHEMA_PROPERTY_TYPE] )

        props = [] # List of template property attributes (shortened name to avoid very long lines)
        property_name_map = []
        property_names = set()

        # Properties are listed alphabetically by their openMINDS name.
        # _property_name_sort_key would instead lead with the naming
        # properties, but applying it would reorder the property block of
        # every generated class, so that remains a separate decision.
        sorted_properties = sorted(
            schema["properties"].items(),
            key=lambda item: _get_openminds_property_name(item[0]),
        )

        for full_name, property_info in sorted_properties:

            openminds_property_name = _get_openminds_property_name(full_name)
            property_name = _create_matlab_name(full_name)

            if property_name in property_names:
                raise ValueError(f"Duplicate MATLAB property name '{property_name}' in schema '{schema_short_name}'.")
            property_names.add(property_name)

            if property_name != openminds_property_name:
                property_name_map.append({
                    "matlab_name": property_name,
                    "openminds_name": openminds_property_name,
                })

            allow_multiple = property_info.get("type") == "array"
            has_linked_type = SCHEMA_PROPERTY_LINKED_TYPES in property_info
            has_embedded_type = SCHEMA_PROPERTY_EMBEDDED_TYPES in property_info

            # Resolve property class name in matlab
            if has_linked_type:
                possible_types = [
                    f'{_generate_class_name(iri, self._class_name_map)}'
                    for iri in property_info[SCHEMA_PROPERTY_LINKED_TYPES]
                ]
            elif has_embedded_type:
                possible_types = [
                    f'{_generate_class_name(iri, self._class_name_map)}'
                    for iri in property_info[SCHEMA_PROPERTY_EMBEDDED_TYPES]
                ]  # todo: handle minItems maxItems, e.g. for axesOrigin
            elif "_formats" in property_info:
                assert property_info["type"] == "string"
                possible_types = sorted(set([format_map[item] for item in property_info["_formats"]]))
            elif property_info.get("type") == "array":
                possible_types = [type_name_map[property_info["items"]["type"]]]
            elif isinstance( property_info.get("type"), list ):
                possible_types = []
            else:
                possible_types = [type_name_map[property_info["type"]]]

            # Resolve property dimension in matlab
            if allow_multiple:
                size_attribute = "(1,:)"
            else:
                size_attribute = "(1,1)"
            size_attribute_doc = size_attribute

            # A MATLAB (1,1) property requires a value, so a scalar that maps a
            # null is declared as a list and constrained to a scalar by a
            # validator instead. The documented size keeps saying (1,1),
            # because that is the cardinality the property actually holds.
            if property_info.get("type") == 'integer':
                size_attribute = "(1,:)"

            # ...ditto for date-time formats
            if _is_datetime_format(property_info):
                size_attribute = "(1,:)"

            # ...and for numbers constrained to a range
            if _is_scalar_number_with_range_validation(property_info):
                size_attribute = "(1,:)"

            # ...and for linked/embedded types
            if has_linked_type or has_embedded_type:
                size_attribute = "(1,:)"
                possible_types_docstr = [_create_matlab_help_link(type_str) for type_str in possible_types]
            else:
                possible_types_docstr = possible_types

            # Resolve property validators in matlab
            validators = _create_property_validator_functions(property_name, property_info)

            mixed_types_list = sorted(possible_types)

            if len(possible_types) == 0:
                possible_types = ''

                # Exception: ParameterSetting from v1. Uses validator instead of type restriction
                if schema_short_name == "ParameterSetting":
                    possible_types_str = ''
                    possible_types_docstr = ", ".join(property_info.get("type"))
                else:
                    possible_types_str = _list_to_string_array(possible_types, do_sort=True)
                    possible_types_docstr = ", ".join(sorted(possible_types_docstr))
            
            elif len(possible_types) == 1:
                possible_types = possible_types[0]
                possible_types_str = f'"{possible_types}"'
                possible_types_docstr = possible_types_docstr[0]
            else:
                possible_types_str = _list_to_string_array(possible_types, do_sort=True)
                possible_types_docstr = ", ".join(sorted(possible_types_docstr))
 
                class_name = _generate_class_name(schema[SCHEMA_PROPERTY_TYPE], self._class_name_map).split(".")[-1]
                possible_types = _create_mixedtype_full_class_name(class_name, property_name)

            template_property_attributes = {
                "name": property_name,
                "type": possible_types,
                "type_doc": possible_types_docstr,
                "type_list": possible_types_str,
                "mixed_type_list": mixed_types_list,
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
        if self._schema_module_name == "controlledTerms":
            controlled_term_base_properties = _get_controlled_term_base_properties(
                self._schema_root_path,
                self.version,
            )
            additional_controlled_term_props = [
                prop for prop in props
                if prop["name"] not in controlled_term_base_properties
            ]
        else:
            additional_controlled_term_props = []

        # Some schemas had the wrong type in older model versions, so this is unreliable
        #class_name = _generate_class_name(schema[SCHEMA_PROPERTY_TYPE], self._class_name_map).split(".")[-1]
        class_name = self._schema_class_name

        display_label_method_expression = _get_display_label_method_expression(class_name, schema["properties"].keys())

        # TODO: Specify base class. Implement template with configurable base class. Schema or ControlledTerm?
        # Or; just remove this as it's not needed when using separate templates.
        if self._schema_module_name == "controlledTerms":
            base_class = "openminds.base.ControlledTerm"
        else:
            base_class = "openminds.Node"

        has_controlled_instance = class_name in types_with_controlled_instances
        if has_controlled_instance:
            # Add the controlled instance mixin to the base class
            base_class = base_class + " & openminds.internal.mixin.HasControlledInstance"

        if self._schema_module_name == "controlledTerms":
            instance_loader = InstanceLoader()
            # Pass the schema's filename as this should match the foldername where instances are stored
            known_instance_list = instance_loader.get_instance_collection(self.version, self._schema_file_name)
            known_instance_list.sort()
        else:
            known_instance_list = []

        self._template_variables = {
            "class_name": class_name,
            "full_class_name": _generate_class_name(schema[SCHEMA_PROPERTY_TYPE], self._class_name_map),
            "base_class": base_class,
            "has_controlled_instance": has_controlled_instance,
            "openminds_type": _expand_type_namespace( schema[SCHEMA_PROPERTY_TYPE] ),
            "docstring": schema.get("description", "No description available."),
            "props": props,
            "max_property_name_length": max_property_name_length,
            "required_properties": [f'{prop["name"]}' for prop in props if prop["required"]],
            "linked_types": linked_types,
            "embedded_types": embedded_types,
            "additional_controlled_term_props": additional_controlled_term_props,
            "property_name_map": property_name_map,
            "display_label_method_expression": display_label_method_expression,
            "known_instance_list": known_instance_list,
        }
        
    def _expand_schema_template(self) -> str:
        # print(f"Expanding template for {self._schema_file_name}")

        template_variables = self._template_variables
        result = self.class_template.render(template_variables)
        return _strip_trailing_whitespace(result)

    def _generate_additional_files(self):
        """
        Create mixedtype classes for linked/embedded types with multiple possible types
        """

        # Create mixedtype class 
        for prop in self._template_variables["props"]:
            if prop["is_linked"] or prop["is_embedded"]:
                if len(prop["mixed_type_list"]) > 1:
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

        template_variables = {
            "class_name": property_name,
            "allowed_types_list": prop['mixed_type_list'],
            "is_scalar": str(not(prop['allow_multiple'])).lower(),
        }

        mixedtype_classdef_str = self.mixedtype_class_template.render(template_variables)
        mixedtype_classdef_str = _strip_trailing_whitespace(mixedtype_classdef_str)

        with open(file_path, "w", encoding="utf-8") as target_file:
            target_file.write(mixedtype_classdef_str)


# # # LOCAL UTILITY FUNCTIONS # # #

def _create_matlab_name(json_name):
    """Remove the openMINDS prefix from a name"""
    property_name = _get_openminds_property_name(json_name)
    return PROPERTY_NAME_OVERRIDES.get(property_name, property_name)

def _get_openminds_property_name(json_name):
    """Remove the openMINDS prefix from a property name"""
    return json_name.split('/')[-1]


def save_controlled_term_base_class(version, schema_root_path, class_name_map, jinja_templates):
    """Generate the controlled term base class for a schema version.

    The properties shared by the controlled term schemas of a model version
    differ between versions, so the base class holding them is generated per
    version alongside the types rather than maintained by hand.
    """
    base_property_names = _get_controlled_term_base_properties(schema_root_path, version)
    if not base_property_names:
        # Model versions without a controlled terms module need no base class.
        return None

    schema_file_path = _find_controlled_term_schema(
        schema_root_path, version, base_property_names
    )

    builder = MATLABSchemaBuilder(
        schema_file_path, schema_root_path, class_name_map, jinja_templates
    )
    props = [
        prop for prop in builder.get_property_definitions()
        if prop["name"] in base_property_names
    ]

    classdef_str = jinja_templates["controlledterm_base_class"].render({"props": props})
    classdef_str = _strip_trailing_whitespace(classdef_str)

    target_file_path = os.path.join(
        "target", "base", version, "+openminds", "+base", "ControlledTerm.m"
    )
    os.makedirs(os.path.dirname(target_file_path), exist_ok=True)
    with open(target_file_path, "w", encoding="utf-8") as target_file:
        target_file.write(classdef_str)

    return target_file_path


def _find_controlled_term_schema(schema_root_path, version, property_names):
    """Return the controlled term schema whose properties are exactly the given set.

    The base property set is taken from the schemas themselves, so at least one
    schema declares it and no more than its own properties are needed to render
    the base class.
    """
    schema_file_paths = sorted(glob.glob(
        os.path.join(schema_root_path, version, "controlledTerms", f"*{SCHEMA_FILE_EXTENSION}")
    ))

    for schema_file_path in schema_file_paths:
        with open(schema_file_path, "r", encoding="utf-8") as schema_file:
            schema_payload = json.load(schema_file)

        schema_property_names = {
            _create_matlab_name(property_name)
            for property_name in schema_payload.get("properties", {})
        }
        if schema_property_names == property_names:
            return schema_file_path

    raise ValueError(
        f"No controlled term schema in version '{version}' declares the base "
        f"property set {sorted(property_names)}."
    )


def _get_controlled_term_base_properties(schema_root_path, version):
    """Return the common controlled-term property set for a schema version."""
    controlled_term_schema_paths = glob.glob(
        os.path.join(schema_root_path, version, "controlledTerms", f"*{SCHEMA_FILE_EXTENSION}")
    )

    property_sets = Counter()

    for schema_file_path in controlled_term_schema_paths:
        with open(schema_file_path, "r", encoding="utf-8") as schema_file:
            schema_payload = json.load(schema_file)

        property_names = frozenset(
            _create_matlab_name(property_name)
            for property_name in schema_payload.get("properties", {})
        )
        property_sets[property_names] += 1

    if not property_sets:
        return set()

    return set(property_sets.most_common(1)[0][0])


def _generate_class_name(iri, class_name_map):
    """
    Generate a class name from an IRI. 
    E.g https://openminds.ebrains.eu/core/Subject -> openminds.core.Subject
    """
    if iri in class_name_map:
        return class_name_map[iri]

    if iri.startswith("https://"): # v3 and lower
        parts = iri.split("/")[-2:]
    else: # v4 and higher
        parts = iri.split(':')
    
    type_name = parts[-1]

    # Ensure first letter of type_name is capitalized
    type_name = type_name[0].upper() + type_name[1:]

    if type_name not in class_name_map:
        raise KeyError(f"Class name for IRI '{iri}' was not found in the map of all class names.")

    return class_name_map[type_name]


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
        schema_name_label = re.sub("([A-Z])", r" \g<0>", schema_short_name).strip().lower()

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
    """Order the properties that name an instance before the rest.

    The schema keys this is applied to are full openMINDS property IRIs, so
    the priority is looked up on the trailing property name.

    Not currently applied: the generated classes list their properties
    alphabetically, and adopting this order would rewrite the property block
    of every class. See _extract_template_variables.
    """
    full_name, _property_info = arg
    property_name = _get_openminds_property_name(full_name)
    priorities = ["name", "fullName", "shortName", "lookupLabel"]

    if property_name in priorities:
        return (priorities.index(property_name), property_name)
    return (len(priorities), property_name)

def _strip_trailing_whitespace(s):
    return "\n".join([line.rstrip() for line in s.splitlines()]) + "\n" # Also add single newline at the end

def _is_datetime_format(property_info):
    return property_info.get("type") == 'string' \
            and  property_info.get("_formats") \
                and any(item in ["date",  "date-time", "time"] for item in property_info.get("_formats"))

def _is_scalar_number_with_range_validation(property_info):
    return property_info.get("type") == "number" \
        and any(key in property_info for key in ("minimum", "maximum", "exclusiveMinimum", "exclusiveMaximum"))

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


def _get_display_label_method_expression(schema_short_name, property_names):
    """
        Create the display label expression to be added as a getDisplayLabel 
        method in the schema class
    """
    property_names = [_create_matlab_name(name) for name in property_names]

    display_config_filepath = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'instanceDisplayConfig.json')

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

        # A schema may be configured with alternatives, to be tried in order,
        # because a model version can rename the properties a label is built
        # from. The first alternative whose properties the schema declares wins.
        alternatives = config_json[schema_filename]
        if not isinstance(alternatives, list):
            alternatives = [alternatives]

        this_config = None
        for alternative in alternatives:
            prop_names = alternative['propertyName']
            if not prop_names:
                return "str = obj.createLabelForMissingLabelDefinition();"
            if not isinstance(prop_names, list):
                prop_names = [prop_names]
            if all(prop_name in property_names for prop_name in prop_names):
                this_config = alternative
                break

        if this_config is None:
            return _get_default_display_label_method_expression(schema_short_name, property_names)

        str_formatter = this_config['stringFormat']

        # A scalar stringFormat holds a single expression, which is assigned to
        # the output variable here. A list holds a block of statements, which
        # must assign the output variable itself because control flow lines such
        # as "if" cannot be assigned from.
        is_expression = not isinstance(str_formatter, list)
        if is_expression:
            str_formatter = [str_formatter]

        str_formatter = [_qualify_property_names(line, prop_names) for line in str_formatter]

        if is_expression:
            return f"str = {str_formatter[0]};"

        # Join the lines with newline
        return '\n            '.join(str_formatter)
    else:
        return _get_default_display_label_method_expression(schema_short_name, property_names)


# A MATLAB character vector, allowing the doubled quote that escapes one.
# The quote is also the transpose operator, which no display label expression
# uses, so treating every quoted run as a literal is safe here.
CHAR_LITERAL_PATTERN = re.compile(r"('(?:[^']|'')*')")


def _qualify_property_names(expression, property_names):
    """
        Prefix every reference to a schema property in a display label
        expression with "obj.", so that it resolves against the instance.

        Matches are anchored on identifier boundaries and skip names preceded by
        a dot. This keeps a short property name from being rewritten inside a
        longer one ("minValue" within "minValueUnit") and leaves the namespace
        segments of a qualified function call untouched. Character literals are
        left alone, so that a format string may use a property name as text.
    """
    # Splitting on a capturing group alternates unquoted and quoted segments,
    # so the even indices hold the code to rewrite.
    segments = CHAR_LITERAL_PATTERN.split(expression)
    for index in range(0, len(segments), 2):
        for property_name in property_names:
            pattern = r"(?<![\w.])" + re.escape(property_name) + r"(?!\w)"
            segments[index] = re.sub(
                pattern, f"obj.{property_name}", segments[index]
            )
    return "".join(segments)


def _get_default_display_label_method_expression(schema_short_name, property_names):
    """Create a display label expression from schema properties."""

    if "lookupLabel" in property_names:
        return "str = obj.lookupLabel;"
    elif "fullName" in property_names:
        return "str = obj.fullName;"
    elif "identifier" in property_names:
        return "str = obj.identifier;"
    elif "name" in property_names:
        return "str = obj.name;"
    else:
        print(f"No display label method found for {schema_short_name}.")
        return "str = obj.createLabelForMissingLabelDefinition();"


def _create_property_validator_functions(name, property_info):

    property_name = name
    allow_multiple = property_info.get("type") == "array"
    has_linked_type = SCHEMA_PROPERTY_LINKED_TYPES in property_info
    has_embedded_type = SCHEMA_PROPERTY_EMBEDDED_TYPES in property_info

    validation_functions = []

    if property_info.get("type") == 'integer':
        validation_functions += [f'mustBeScalarOrEmpty({property_name})']

    if _is_scalar_number_with_range_validation(property_info):
        validation_functions += [f'mustBeScalarOrEmpty({property_name})']

    if _is_datetime_format(property_info):
        validation_functions += [f'mustBeScalarOrEmpty({property_name})']

        if "date" in property_info.get("_formats"):
            validation_functions += [f"mustBeValidDate({property_name})"]
        elif "time" in property_info.get("_formats"):
            validation_functions += [f"mustBeValidTime({property_name})"]

    if isinstance( property_info.get("type"), list ):
        validation_functions += [f'mustBeA({property_name}, ["numeric", "string"])']

    if has_linked_type or has_embedded_type:
        if not allow_multiple:
            validation_functions += [f'mustBeScalarOrEmpty({property_name})']

    if 'minItems' in property_info or 'maxItems' in property_info:
        has_min_items = 'minItems' in property_info
        has_max_items = 'maxItems' in property_info

        if has_min_items and has_max_items:
            min_items = property_info['minItems']
            max_items = property_info['maxItems']
            validation_functions += [f"mustBeMinLength({name}, {min_items})"]
            validation_functions += [f"mustBeMaxLength({name}, {max_items})"]
        elif has_min_items:
            validation_functions += [f"mustBeMinLength({name}, {property_info['minItems']})"]
        elif has_max_items:
            validation_functions += [f"mustBeMaxLength({name}, {property_info['maxItems']})"]

    if property_info.get('uniqueItems') is True:
        validation_functions += [f"mustBeListOfUniqueItems({name})"]

    if 'minLength' in property_info or 'maxLength' in property_info:
        min_length = property_info.get('minLength', 0)
        max_length = property_info.get('maxLength', float('inf'))
        validation_functions += [f"mustBeValidStringLength({name}, {min_length}, {max_length})"]

    if 'pattern' in property_info:
        if 'archive.softwareheritage' in property_info['pattern']:
            print("SWHID str pattern validation is hard-coded")
            escaped_str_pattern = r"^https://archive.softwareheritage.org/swh:1:(cnt|dir|rel|rev|snp):[0-9a-f]{40}(;(origin|visit|anchor|path|lines)=[^ \t\r\n\f]+)*$"
        else:
            escaped_str_pattern = property_info['pattern']

        validation_functions += [f"mustMatchPattern({name}, '{escaped_str_pattern}')"]

    if any(key in property_info for key in ('minimum', 'maximum', 'exclusiveMinimum', 'exclusiveMaximum')):
        if property_info.get("type") == "integer":
            validation_functions += [f"mustBeInteger({name})"]

        if 'minimum' in property_info and 'maximum' in property_info:
            min_value = property_info['minimum']
            max_value = property_info['maximum']
            validation_functions += [f"mustBeInRange({name}, {min_value}, {max_value})"]
        elif 'minimum' in property_info:
            validation_functions += [f"mustBeGreaterThanOrEqual({name}, {property_info['minimum']})"]
        elif 'maximum' in property_info:
            validation_functions += [f"mustBeLessThanOrEqual({name}, {property_info['maximum']})"]

        if 'exclusiveMinimum' in property_info:
            validation_functions += [f"mustBeGreaterThan({name}, {property_info['exclusiveMinimum']})"]

        if 'exclusiveMaximum' in property_info:
            validation_functions += [f"mustBeLessThan({name}, {property_info['exclusiveMaximum']})"]

    return validation_functions


def _expand_type_namespace( type_specifier ):
    if type_specifier.startswith('https://'):
        # For versions 3 and below, the type specifier is already fully expanded in the schema
        return type_specifier
    else:
        schema_type_name = type_specifier.split(':')[-1]
        return f"{OPENMINDS_BASE_URI['latest']}/types/{schema_type_name}"


def _parse_schema_type(type_specifier):

    if type_specifier.startswith('https://'):
        # Example type_specifier: https://openminds.ebrains.eu/chemicals/AmountOfChemical
        return os.path.basename(type_specifier)
    else:
        # Example type_specifier: chemicals:AmountOfChemical
        return type_specifier.split(":")[-1]


if __name__ == "__main__":
    raise NotImplementedError
