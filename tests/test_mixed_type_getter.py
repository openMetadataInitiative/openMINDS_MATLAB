"""Tests for what a generated class does with a mixed type property.

A property that allows several types is declared with a generated mixed type
set class. The set is an implementation detail, so the class hands out the
instances it holds through a property get method. A property with one type
needs no such method. Every property is SetObservable, so the base class can
raise its change events without indexing overrides.
"""

import json
import os
import shutil
import tempfile
import unittest

from pipeline.constants import SCHEMA_PROPERTY_LINKED_TYPES
from pipeline.translator import MATLABSchemaBuilder
from pipeline.utils import initialise_jinja_templates

VERSION = "v9.0"
SCHEMA_TYPE = "https://openminds.ebrains.eu/core/sample"
VOCAB_PREFIX = "https://openminds.ebrains.eu/vocab/"
PERSON_TYPE = "https://openminds.ebrains.eu/core/Person"
ORGANIZATION_TYPE = "https://openminds.ebrains.eu/core/Organization"

CLASS_NAME_MAP = {
    SCHEMA_TYPE: "openminds.core.Sample",
    PERSON_TYPE: "openminds.core.actors.Person",
    ORGANIZATION_TYPE: "openminds.core.actors.Organization",
}

PROPERTY_NAME = "author"


class MixedTypeGetterTest(unittest.TestCase):

    def setUp(self):
        self.root = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.root, ignore_errors=True)
        self.schema_folder = os.path.join(self.root, VERSION, "core")
        os.makedirs(self.schema_folder)

        self.output_directory = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.output_directory, ignore_errors=True)
        self.addCleanup(os.chdir, os.getcwd())

    def generate_with_linked_types(self, linked_types):
        """Return the generated class for a schema with one linked property."""
        payload = {
            "_type": SCHEMA_TYPE,
            "properties": {
                # A name property keeps the class out of the missing display
                # label path; only the property under test is inspected.
                f"{VOCAB_PREFIX}name": {"type": "string"},
                f"{VOCAB_PREFIX}{PROPERTY_NAME}": {
                    "type": "array",
                    "items": {"type": "object"},
                    SCHEMA_PROPERTY_LINKED_TYPES: linked_types,
                },
            },
            "required": [],
        }
        path = os.path.join(self.schema_folder, "sample.schema.omi.json")
        with open(path, "w", encoding="utf-8") as schema_file:
            json.dump(payload, schema_file)

        os.chdir(self.output_directory)
        return MATLABSchemaBuilder(
            path,
            self.root,
            CLASS_NAME_MAP,
            initialise_jinja_templates(),
        ).translate()

    def test_mixed_type_property_has_a_get_method_that_unwraps(self):
        generated = self.generate_with_linked_types([PERSON_TYPE, ORGANIZATION_TYPE])
        self.assertRegex(
            generated, rf"(?m)^        function value = get\.{PROPERTY_NAME}\(obj\)$"
        )
        self.assertIn(f"value = obj.{PROPERTY_NAME}.unwrap();", generated)

    def test_single_type_property_has_no_get_method(self):
        generated = self.generate_with_linked_types([PERSON_TYPE])
        self.assertNotIn(f"get.{PROPERTY_NAME}", generated)
        self.assertNotIn("Hand out the instances", generated)

    def test_properties_are_set_observable(self):
        generated = self.generate_with_linked_types([PERSON_TYPE])
        self.assertIn("properties (SetObservable)", generated)


if __name__ == "__main__":
    unittest.main()
