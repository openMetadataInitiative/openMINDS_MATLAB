import os.path
import shutil

from pipeline.translator import MATLABSchemaBuilder
from pipeline.utils import clone_sources, SchemaLoader, initialise_jinja_templates, save_resource_files, save_enumeration_classes, get_class_name_map

print("***************************************")
print(f"Triggering the generation of MATLAB-Classes for openMINDS")
print("***************************************")

# Step 1 - clone central repository in main branch to get the latest sources
clone_sources()
schema_loader = SchemaLoader()
if os.path.exists("target"):
    shutil.rmtree("target")

# Step 2 - Initialise the jinja templates
jinja_templates = initialise_jinja_templates()

for schema_version in schema_loader.get_schema_versions():

    # Step 3 - find all involved schemas for the current version
    schemas_file_paths = schema_loader.find_schemas(schema_version)
    # schemas_file_paths = [path for path in schemas_file_paths if "person" in path] # testing

    class_name_map = get_class_name_map(schema_loader, schema_version)

    for schema_file_path in schemas_file_paths:
        # Step 4 - translate and build each openMINDS schema as MATLAB class
        schema_root_path = schema_loader.schemas_sources

        try:
            MATLABSchemaBuilder(schema_file_path, schema_root_path, class_name_map, jinja_templates).build()
        except Exception as e:
            print(f"Error while building schema {schema_file_path}: {e}")

    save_resource_files(schema_version, schemas_file_paths)
    
    save_enumeration_classes("Types", schema_version, schema_loader, jinja_templates["types_enumeration"])
    save_enumeration_classes("Models", schema_version, schema_loader, jinja_templates["models_enumeration"])
