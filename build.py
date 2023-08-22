import os.path
import shutil

from pipeline.translator import MATLABSchemaBuilder
from pipeline.utils import clone_sources, SchemaLoader, initialise_jinja_template_environment, save_resource_files

print("***************************************")
print(f"Triggering the generation of MATLAB-Classes for openMINDS")
print("***************************************")

# Step 1 - clone central repository in main branch to get the latest sources
clone_sources()
schema_loader = SchemaLoader()
if os.path.exists("target"):
    shutil.rmtree("target")

for schema_version in schema_loader.get_schema_versions():

    # Step 2 - Initialise the jinja template environment
    jinja_template_environment = initialise_jinja_template_environment()

    # Step 3 - find all involved schemas for the current version
    schemas_file_paths = schema_loader.find_schemas(schema_version)
    # schemas_file_paths = [path for path in schemas_file_paths if "person" in path] # testing

    for schema_file_path in schemas_file_paths:
        # Step 4 - translate and build each openMINDS schema as MATLAB class
        schema_root_path = schema_loader.schemas_sources
        try:
            MATLABSchemaBuilder(schema_file_path, schema_root_path, jinja_template_environment).build()
        except Exception as e:
            print(f"Error while building schema {schema_file_path}: {e}")

    save_resource_files(schema_version, schemas_file_paths)


