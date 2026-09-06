import glob
import json
import os
import re
import shutil
from functools import lru_cache
from typing import List

from git import Repo
from jinja2 import Environment, FileSystemLoader
from jinja2 import Template

# Every openMINDS schema source file carries this compound extension
SCHEMA_FILE_EXTENSION = ".schema.omi.json"

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
        return glob.glob(
            os.path.join(self.schemas_sources, version, "**", f"*{SCHEMA_FILE_EXTENSION}"),
            recursive=True,
        )

class InstanceLoader(object):

    def __init__(self):
        self._root_directory = os.path.realpath(".")
        self.instances_sources = os.path.join(self._root_directory, "_sources", "openMINDS_instances", "instances")

    def get_instance_versions(self) -> List[str]:
        return os.listdir(self.instances_sources)

    def find_instances(self, version:str, schema_name:str=None) -> List[str]:
        instance_paths = _find_all_instances(self.instances_sources, version)

        if schema_name:
            # An instance belongs to a schema when it sits directly in a folder
            # named after that schema
            return [
                instance_path for instance_path in instance_paths
                if os.path.basename(os.path.dirname(instance_path)) == schema_name
            ]

        return list(instance_paths)

    def get_instance_collection(self, version:str, schema_file_name:str) -> List[str]:
        
        # Get list of all instance jsonld files in the given version for the given schema
        # This is a list of absolute pathnames
        instance_list_complete = self.find_instances(version, schema_file_name)

        instance_list = [instance for instance in instance_list_complete if schema_file_name in instance]
        instance_list = [extract_filename_without_extension(path_str) for path_str in instance_list]
        
        # Show warning if no instances found
        if len(instance_list) == 0:
            print(f"Warning: No instances found for schema '{schema_file_name}' in version '{version}'")
            return []

        return instance_list
    
@lru_cache(maxsize=None)
def _find_all_instances(instances_sources: str, version: str):
    """Every instance file of a model version, as a tuple of paths.

    Walking the instances of a version is the most expensive thing the build
    does, and a version holds one folder of instances per controlled term, so
    the walk is done once per version and the result filtered in memory.
    """
    return tuple(glob.glob(
        os.path.join(instances_sources, version, "**", "*.jsonld"), recursive=True
    ))


def initialise_jinja_templates():
    """
    Initializes a Jinja2 environment and preloads templates into a dictionary for reuse.

    This function sets up a Jinja2 `Environment` for loading templates from the `templates`
    subdirectory within the current script's directory. It then preloads a set of named templates
    into a dictionary, making them accessible by key for efficient repeated rendering. This
    approach avoids repeated environment initialization and template loading, optimizing
    performance when rendering templates multiple times.

    Returns:
    --------
    dict
        A dictionary of preloaded Jinja2 template objects keyed by descriptive names, allowing 
        access to specific templates. The available templates are:
        - `"schema_class"`: Template for schema class generation.
        - `"controlledterm_class"`: Template for controlled term class generation.
        - `"mixedtype_class"`: Template for mixed type class generation.
        - `"controlledterm_base_class"`: Template for the controlled term base class.
        - `"modules_enumeration"`: Template for modules enumeration generation.
        - `"types_enumeration"`: Template for types enumeration generation.

    Notes:
    ------
    - The function uses `os.path.dirname(os.path.realpath(__file__))` to locate the directory of
      the current script, ensuring templates are loaded from the `templates` subdirectory.

    Example Usage:
    --------------
    templates = initialise_jinja_templates()
    rendered_schema = templates["schema_class"].render(data=schema_data)
    """

    module_directory = os.path.dirname(os.path.realpath(__file__))
    template_directory = os.path.join(module_directory, "templates")

    jinja_environment = Environment(
        loader=FileSystemLoader(template_directory),
        # Autoescaping is HTML escaping, which would corrupt the generated
        # MATLAB: the "&" joining a base class to a mixin and the help links
        # in property docstrings would come out as entities.
        autoescape=False
    )

    jinja_templates = {
        "schema_class": jinja_environment.get_template("schema_class_template.txt"),
        "controlledterm_class": jinja_environment.get_template("controlledterm_class_template.txt"),
        "controlledterm_base_class": jinja_environment.get_template("controlledterm_base_class_template.txt"),
        "mixedtype_class": jinja_environment.get_template("mixedtype_class_template.txt"),
        "modules_enumeration": jinja_environment.get_template("modules_enumeration_template.txt"),
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
    # Which schema claimed each type name, to report a name used by two schemas
    schema_file_by_type_name = {}

    for schema_file in schema_files:
        schema_info = parse_schema_file_path(schema_file, root_path)
        matlab_class_name = _get_matlab_class_name(schema_info)

        with open(schema_file, "r", encoding="utf-8") as file:
            schema_payload = json.load(file)

        if "_type" in schema_payload:
            class_name_map[schema_payload["_type"]] = matlab_class_name

        type_name = schema_info['type_name']
        # A type name is expected to be unique across modules, so resolving a
        # type by name alone is ambiguous when two schemas share one. The first
        # schema in sorted order wins; warn so the collision is not silent.
        if type_name in schema_file_by_type_name:
            print(
                f"Warning: Type name '{type_name}' is declared by more than one schema "
                f"in version '{version}'. Resolving it by name gives "
                f"'{class_name_map[type_name]}' "
                f"(from '{os.path.relpath(schema_file_by_type_name[type_name], root_path)}'), "
                f"not '{matlab_class_name}' "
                f"(from '{os.path.relpath(schema_file, root_path)}')."
            )
        else:
            schema_file_by_type_name[type_name] = schema_file

        class_name_map.setdefault(type_name, matlab_class_name)

    # Add some exceptions
    if version == "v2.0":
        class_name_map["AnatomicalEntity"] = class_name_map["CustomAnatomicalEntity"]
        class_name_map["https://openminds.ebrains.eu/sands/AnatomicalEntity"] = class_name_map["CustomAnatomicalEntity"]


    return class_name_map

def camel_case(text_string: str):
    return text_string[0].lower() + text_string[1:]

def extract_filename_without_extension(path):
    base_name = os.path.basename(path)  # Get the base name from the path
    if '.' in base_name:
        return base_name.rsplit('.', 1)[0]
    return base_name

def save_resource_files(version, schema_path_list, schema_root_path):
    """
        Creates:
            - manifest json file for the schemas
            - alias json file with alias definitions (to support
              creation of MATLAB classes without group name)
    """

    alias_list = []
    manifest = []

    for schema_path in sorted(schema_path_list):
        schema_info = parse_schema_file_path(schema_path, schema_root_path)

        # Create meta dict for schema
        schema_meta = {}
        schema_meta["name"] = schema_info["file_name"]
        schema_meta["module"] = schema_info["module_name"]
        schema_meta["group"] = schema_info["group_name"]

        if schema_meta["group"]: # Create alias definition for schema
            alias_def = {}
            short_class_name = schema_info["type_name"]
            module_name = namespace_name(schema_meta["module"])
            group_name = namespace_name(schema_meta["group"])
            alias_def["NewName"] = ".".join(["openminds", module_name, group_name, short_class_name])
            alias_def["OldNames"] = ".".join(["openminds", module_name, short_class_name])
            alias_def["WarnOnOldName"] = False
            if version not in ["v1.0", "v2.0", "v3.0"]:
                alternative_old_name = ".".join(["openminds", short_class_name])
                # Append to old names where old names should be a list
                alias_def["OldNames"] = [alias_def["OldNames"], alternative_old_name]
            alias_list.append(alias_def)

        manifest.append(schema_meta)

    manifest.sort(key=lambda x: x["name"])
    alias_json = {'Aliases': alias_list}

    target_directory = os.path.join("target", "types", version, "resources")
    os.makedirs(target_directory, exist_ok=True)

    # Save manifest to file as json
    with open(os.path.join(target_directory, "schema_manifest.json"), "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=4)
        f.write("\n")

    # Save alias definitions to file as json
    with open(os.path.join(target_directory, "alias.json"), "w", encoding="utf-8") as f:
        json.dump(alias_json, f, indent=2)
        f.write("\n")

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
    enum_classdef_str = _strip_trailing_whitespace(enum_classdef_str)

    with open(target_file_path, "w", encoding="utf-8") as target_file:
        target_file.write(enum_classdef_str)


def capitalize_first_letter(text_string: str):
    return text_string[0].upper() + text_string[1:]


def parse_schema_file_path(schema_file_path: str, root_path: str) -> dict:
    """Split a schema source path into the openMINDS parts it is built from.

    A schema file lives at <version>/<module>/[<group>/]<name>.schema.omi.json
    below the schemas root. The version, module, group and file name are
    returned as they appear in the path. Use namespace_name to turn a module
    or group into the MATLAB namespace segment for it.
    """
    relative_path = os.path.relpath(schema_file_path, root_path)
    if relative_path.endswith(SCHEMA_FILE_EXTENSION):
        relative_path = relative_path[:-len(SCHEMA_FILE_EXTENSION)]

    path_parts = relative_path.split(os.sep)
    file_name = path_parts[-1]
    has_group = len(path_parts) > 3

    return {
        "version": path_parts[0],
        "module_name": path_parts[1],
        "group_name": path_parts[2] if has_group else None,
        "file_name": file_name,
        "type_name": capitalize_first_letter(file_name),
    }


def namespace_name(path_part: str) -> str:
    """MATLAB namespace segment for a module or group name.

    A group such as "non-atlas" is not a valid MATLAB identifier, so every
    non-alphanumeric character is removed.
    """
    return re.sub(r'\W+', '', path_part).lower()


# Local functions
def _create_enum_target_file_path(version, enum_type) -> str:
        target_root_path = os.path.join("target", "enumerations", version, '+openminds', '+enum', f"{enum_type}.m")
        return target_root_path

def _get_matlab_class_name(schema_info):
    """Fully qualified MATLAB class name for a parsed schema path"""

    namespace_parts = ["openminds", namespace_name(schema_info["module_name"])]
    if schema_info["group_name"]:
        namespace_parts.append(namespace_name(schema_info["group_name"]))

    return ".".join(namespace_parts + [schema_info["type_name"]])


def _get_template_variables(enum_type, schema_files, root_path):
    """ Extracts all type names and full class names from the schema files"""

    # Build a list for all the enumeration members
    template_variable_list = []
    # Class name already enumerated for each type name, to report a collision
    class_name_by_type_name = {}

    for schema_file in schema_files:
        schema_info = parse_schema_file_path(schema_file, root_path)

        if enum_type == "Modules":
            template_variable_list.append(schema_info['module_name'])

        elif enum_type == "Types":
            matlab_class_name = _get_matlab_class_name(schema_info)
            type_name = schema_info['type_name']

            # An enumeration member is named after the type, so a name used by
            # two schemas can only be represented once. Warn about the class
            # left out rather than dropping it silently.
            if type_name in class_name_by_type_name:
                print(
                    f"Warning: Type '{type_name}' is already in the Types enumeration for "
                    f"version '{schema_info['version']}' as "
                    f"'{class_name_by_type_name[type_name]}'. "
                    f"'{matlab_class_name}' is left out."
                )
                continue

            class_name_by_type_name[type_name] = matlab_class_name
            template_variable_list.append({'name': type_name, 'class_name': matlab_class_name})
        
    if enum_type == "Types":
        return {'types': template_variable_list }
    
    elif enum_type == "Modules":
        return {'modules': sorted(set(template_variable_list)) }
    
def _strip_trailing_whitespace(s):
    return "\n".join([line.rstrip() for line in s.splitlines()]) + "\n" # Also add single newline at the end
