import glob
import json
import os
import re
import shutil
from typing import List

from git import Repo, GitCommandError
from jinja2 import Environment, select_autoescape, FileSystemLoader

def clone_sources():
    # cloning central repo (for schemas)
    if os.path.exists("sources"):
        shutil.rmtree("sources")
    Repo.clone_from("https://github.com/openMetadataInitiative/openMINDS.git", to_path="sources", depth=1)

    # cloning instances repo (for instances)
    if os.path.exists("sources_instances"):
        shutil.rmtree("sources_instances")
    Repo.clone_from("https://github.com/openMetadataInitiative/openMINDS_instances.git", to_path="sources_instances", depth=1)

class SchemaLoader(object):

    def __init__(self):
        self._root_directory = os.path.realpath(".")
        self.schemas_sources = os.path.join(self._root_directory, "sources", "schemas")

    def get_schema_versions(self) -> List[str]:
        return os.listdir(self.schemas_sources)

    def find_schemas(self, version:str) -> List[str]:
        return glob.glob(os.path.join(self.schemas_sources, version, f'**/*.schema.omi.json'), recursive=True)

class InstanceLoader(object):

    def __init__(self):
        self._root_directory = os.path.realpath(".")
        self.instances_sources = os.path.join(self._root_directory, "sources_instances", "instances")

    def get_instance_versions(self) -> List[str]:
        return os.listdir(self.instances_sources)

    def find_instances(self, version:str) -> List[str]:
        return glob.glob(os.path.join(self.instances_sources, version, f'**/*.jsonld'), recursive=True)

    def get_instance_collection(self, version:str, schema_name:str) -> List[str]:
        instance_list_complete = self.find_instances(version)

        if schema_name == schema_name.upper():
            pass
        else:
            schema_name = camel_case(schema_name)

        instance_list = [instance for instance in instance_list_complete if schema_name in instance]
        instance_list = [extract_filename_without_extension(path_str) for path_str in instance_list]
        if schema_name in instance_list:
            instance_list.remove(schema_name)

        return instance_list
    
def initialise_jinja_template_environment(autoescape:bool=None):
    return Environment(
        loader=FileSystemLoader(os.path.dirname(os.path.realpath(__file__))),
        autoescape=select_autoescape(autoescape) if autoescape is not None else select_autoescape()
    )

def camel_case(text_string: str):
    return text_string[0].lower() + text_string[1:]

    #return ''.join(x.capitalize() or '_' for x in str.split('_'))
    
def extract_filename_without_extension(path):
    base_name = os.path.basename(path)  # Get the base name from the path
    return base_name.split('.')[0]

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
        schema_path = schema_path.replace(f"/sources/schemas/{version}/", "")
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

def capitalize_first_letter(text_string: str):
    return text_string[0].upper() + text_string[1:]
