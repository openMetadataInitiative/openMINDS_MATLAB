import glob
import json
import os
import re
import shutil
from typing import List

from git import Repo, GitCommandError
from jinja2 import Environment, select_autoescape, FileSystemLoader
from jinja2 import Template

def clone_sources():

    if os.path.exists("_sources"):
        shutil.rmtree("_sources")

    # cloning central repo (for schemas)
    Repo.clone_from(
        "https://github.com/openMetadataInitiative/openMINDS.git",
        to_path="_sources/openMINDS",
        depth=1,
    )
        
    # cloning instances repo (for instances)
    Repo.clone_from(
        "https://github.com/openMetadataInitiative/openMINDS_instances.git",
        to_path="_sources/openMINDS_instances",
        depth=1,
    )

class SchemaLoader(object):

    def __init__(self):
        self._root_directory = os.path.realpath(".")
        self.schemas_sources = os.path.join(self._root_directory, "_sources", "openMINDS", "schemas")

    def get_schema_versions(self) -> List[str]:
        return os.listdir(self.schemas_sources)

    def find_schemas(self, version:str) -> List[str]:
        return glob.glob(os.path.join(self.schemas_sources, version, f'**/*.schema.omi.json'), recursive=True)

class InstanceLoader(object):

    def __init__(self):
        self._root_directory = os.path.realpath(".")
        self.instances_sources = os.path.join(self._root_directory, "_sources", "openMINDS_instances", "instances")

    def get_instance_versions(self) -> List[str]:
        return os.listdir(self.instances_sources)

    def find_instances(self, version:str, schema_name:str=None) -> List[str]:
        if schema_name:
            return glob.glob(os.path.join(self.instances_sources, version, f'**/{schema_name}/*.jsonld'), recursive=True)
        else:
            return glob.glob(os.path.join(self.instances_sources, version, f'**/*.jsonld'), recursive=True)

    def get_instance_collection(self, version:str, schema_name:str) -> List[str]:

        # Make sure schema_name is correct casing (camel case) according to foldernames
        if schema_name == schema_name.upper():
            pass
        elif schema_name in ["UBERONParcellation", "MRIPulseSequence"]:
            # Todo: Need to find a general solution for these exceptions.
            pass
        else:
            schema_name = camel_case(schema_name)

        # Get list of all instance jsonld files in the given version for the given schema
        # This is a list of absolute pathnames
        instance_list_complete = self.find_instances(version, schema_name)

        instance_list = [instance for instance in instance_list_complete if schema_name in instance]
        instance_list = [extract_filename_without_extension(path_str) for path_str in instance_list]
        
        return instance_list
    
def initialise_jinja_templates(autoescape:bool=None):
    """
    Initializes a Jinja2 environment and preloads templates into a dictionary for reuse.

    This function sets up a Jinja2 `Environment` for loading templates from the `templates` 
    subdirectory within the current script's directory. It then preloads a set of named templates 
    into a dictionary, making them accessible by key for efficient repeated rendering. This 
    approach avoids repeated environment initialization and template loading, optimizing 
    performance when rendering templates multiple times.

    Parameters:
    -----------
    autoescape : bool, optional
        Configures the autoescaping behavior for templates:
        - `True` enables autoescaping for all templates.
        - `False` disables autoescaping.
        - `None` (default) uses Jinja2's `select_autoescape()` function to enable autoescaping for 
          specific file types (e.g., `.html`, `.xml`).

    Returns:
    --------
    dict
        A dictionary of preloaded Jinja2 template objects keyed by descriptive names, allowing 
        access to specific templates. The available templates are:
        - `"schema_class"`: Template for schema class generation.
        - `"controlledterm_class"`: Template for controlled term class generation.
        - `"mixedtype_class"`: Template for mixed type class generation.
        - `"models_enumeration"`: Template for models enumeration generation.
        - `"types_enumeration"`: Template for types enumeration generation.

    Notes:
    ------
    - The function uses `os.path.dirname(os.path.realpath(__file__))` to locate the directory of 
      the current script, ensuring templates are loaded from the `templates` subdirectory.
    - Autoescaping is configured to help prevent injection attacks for templates handling HTML or XML.

    Example Usage:
    --------------
    templates = initialise_jinja_templates(autoescape=True)
    rendered_schema = templates["schema_class"].render(data=schema_data)
    """

    module_directory = os.path.dirname(os.path.realpath(__file__))
    template_directory = os.path.join(module_directory, "templates")
    
    jinja_environment = Environment(
        loader=FileSystemLoader(template_directory),
        autoescape=select_autoescape(autoescape) if autoescape is not None else select_autoescape()
    )

    jinja_templates = {
        "schema_class": jinja_environment.get_template("schema_class_template.txt"),
        "controlledterm_class": jinja_environment.get_template("controlledterm_class_template.txt"),
        "mixedtype_class": jinja_environment.get_template("mixedtype_class_template.txt"),
        "models_enumeration": jinja_environment.get_template("models_enumeration_template.txt"),
        "types_enumeration": jinja_environment.get_template("types_enumeration_template.txt"),
    }

    return jinja_templates


def get_class_name_map(schema_loader, version):
    # Extract all schema files
    root_path = schema_loader.schemas_sources
    schema_files = schema_loader.find_schemas(version)
    schema_files.sort()

    # Build a list for all the enumeration members
    class_name_map = {}

    for schema_file in schema_files:
        schema_info = _parse_source_file_path(schema_file, root_path)
        class_name_map[schema_info['type_name']] = _get_matlab_class_name(schema_info)

    # Add some exceptions
    if version == "v2.0":
        print(class_name_map["CustomAnatomicalEntity"])
        class_name_map["AnatomicalEntity"] = class_name_map["CustomAnatomicalEntity"]


    return class_name_map

def camel_case(text_string: str):
    return text_string[0].lower() + text_string[1:]

    #return ''.join(x.capitalize() or '_' for x in str.split('_'))
    
def extract_filename_without_extension(path):
    base_name = os.path.basename(path)  # Get the base name from the path
    if '.' in base_name:
        return base_name.rsplit('.', 1)[0]
    return base_name

def save_resource_files(version, schema_path_list):
    """
        Creates:
            - manifest json file for the schemas
            - alias json file with alias definitions (to support 
              creation of MATLAB classes without group name)
    """

    root_directory = os.path.realpath(".")
    schema_path_list.sort()

    alias_list = []
    manifest = []

    for schema_path in schema_path_list:
        
        # Remove redundant path information
        schema_path = schema_path.replace(root_directory, "")
        schema_path = schema_path.replace(f"/_sources/openMINDS/schemas/{version}/", "")
        schema_path = schema_path.replace(".schema.omi.json", "")
        if schema_path[0] == "/":
            schema_path = schema_path[1:]

        # Split remaining path into list
        schema_path = schema_path.split("/")

        # Create meta dict for schema
        schema_meta = {}
        schema_meta["name"] = schema_path.pop()
        schema_meta["model"] = schema_path[0]

        if len(schema_path) == 2:
            schema_meta["group"] = schema_path[1]
        else:    
            schema_meta["group"] = None

        if schema_meta["group"]: # Create alias definition for schema
            alias_def = {}
            short_class_name = capitalize_first_letter( schema_meta["name"] )
            model_name = schema_meta["model"].lower()
            group_name = schema_meta["group"].lower()
            group_name = re.sub(r'\W+', '', group_name) # Remove all non alphanumeric characters
            alias_def["NewName"] = ".".join(["openminds", model_name, group_name, short_class_name])
            alias_def["OldNames"] = ".".join(["openminds", model_name, short_class_name])
            alias_def["WarnOnOldName"] = False
            alias_list.append(alias_def)
        else:
            pass

        manifest.append(schema_meta)

    manifest.sort(key=lambda x: x["name"])
    alias_json = {'Aliases': alias_list}

    target_directory = f"target/schemas/{version}/resources"
    os.makedirs(target_directory, exist_ok=True)

    # Save manifest to file as json
    with open(os.path.join(target_directory, "schema_manifest.json"), "w") as f:
        json.dump(manifest, f, indent=4)

    # Save alias definitions to file as json
    with open(os.path.join(target_directory, "alias.json"), "w") as f:
        json.dump(alias_json, f, indent=2)

def save_enumeration_classes(enum_type, version, schema_loader, enumeration_template:Template):

    # Create target file directory
    target_file_path = _create_enum_target_file_path(version, enum_type)
    os.makedirs(os.path.dirname(target_file_path), exist_ok=True)

    # Extract all schema files
    root_path = schema_loader.schemas_sources
    schema_files = schema_loader.find_schemas(version)
    schema_files.sort()

    template_variables = _get_template_variables(enum_type, schema_files, root_path)
    enum_classdef_str = enumeration_template.render(template_variables)

    with open(target_file_path, "w", encoding="utf-8") as target_file:
        target_file.write(enum_classdef_str)


def capitalize_first_letter(text_string: str):
    return text_string[0].upper() + text_string[1:]


# Local functions
def _create_enum_target_file_path(version, enum_type) -> str:
        target_root_path = os.path.join("target", "enumerations", version, '+openminds', '+enum', f"{enum_type}.m")
        return target_root_path

def _parse_source_file_path(schema_file_path:str, root_path:str):
    _relative_path_without_extension = schema_file_path[len(root_path)+1:].replace(".schema.omi.json", "").split("/")
    
    schema_info = {}

    schema_info["version"] = _relative_path_without_extension[0]
    schema_info["model_name"] = _relative_path_without_extension[1]
    if len(_relative_path_without_extension) == 3:
        schema_info["group_name"] = None
    else:
        group_name = _relative_path_without_extension[2]
        # Remove all non alphanumeric characters
        schema_info["group_name"] = re.sub(r'\W+', '', group_name)

    schema_info["type_name"] = _relative_path_without_extension[-1]
    # Ensure first letter is capitalized
    schema_info["type_name"] = capitalize_first_letter(schema_info["type_name"])

    return schema_info

def _get_matlab_class_name(schema_info):

    # Combine the schema_info to get the full namespace name
    if schema_info["group_name"]:
        matlab_namespace_name = f"openminds.{schema_info['model_name']}.{schema_info['group_name']}"
    else:
        matlab_namespace_name = f"openminds.{schema_info['model_name']}"

    matlab_namespace_name = matlab_namespace_name.lower()

    return f"{matlab_namespace_name}.{schema_info['type_name']}"


def _get_template_variables(enum_type, schema_files, root_path):
    """ Extracts all type names and full class names from the schema files"""

    # Build a list for all the enumeration members
    template_variable_list = []

    for schema_file in schema_files:
        schema_info = _parse_source_file_path(schema_file, root_path)

        if enum_type == "Models":
            template_variable_list.append(schema_info['model_name'])

        elif enum_type == "Types":
            matlab_class_name = _get_matlab_class_name(schema_info)
            # Check if type name already exists 
            if schema_info['type_name'] in [item['name'] for item in template_variable_list]:
                # Skip if type name already exists
                continue
            template_variable_list.append({'name': schema_info['type_name'], 'class_name': matlab_class_name})
        
    if enum_type == "Types":
        return {'types': template_variable_list }
    
    elif enum_type == "Models":
        return {'models': sorted(set(template_variable_list)) }
