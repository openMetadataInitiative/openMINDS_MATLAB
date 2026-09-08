"""Tests for how a generated class declares a mixed type property.

A property that allows several types is declared with a generated mixed type
set class. The set redefines paren indexing, and MATLAB cannot synthesize a
(1,:) default for such a class, so the declaration carries an explicit empty
set. Every property is SetObservable, so the base class can raise its change
events without indexing overrides. The set class itself defines the static
empty that RedefinesParen requires, since an abstract base cannot know which
subclass was asked for.
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
MIXED_TYPE_CLASS = "openminds.internal.mixedtype.sample.Author"


class MixedTypeDeclarationTest(unittest.TestCase):

    def setUp(self):
        self.root = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.root, ignore_errors=True)
        self.schema_folder = os.path.join(self.root, VERSION, "core")
        os.makedirs(self.schema_folder)

        self.output_directory = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.output_directory, ignore_errors=True)
        self.addCleanup(os.chdir, os.getcwd())

    def builder_with_linked_types(self, linked_types, **extra):
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
                    **extra,
                },
            },
            "required": [],
        }
        path = os.path.join(self.schema_folder, "sample.schema.omi.json")
        with open(path, "w", encoding="utf-8") as schema_file:
            json.dump(payload, schema_file)

        os.chdir(self.output_directory)
        return MATLABSchemaBuilder(
            path, self.root, CLASS_NAME_MAP, initialise_jinja_templates()
        )

    def test_mixed_type_property_defaults_to_an_empty_set(self):
        generated = self.builder_with_linked_types([PERSON_TYPE, ORGANIZATION_TYPE]).translate()
        self.assertIn(
            f"        {PROPERTY_NAME} (1,:) {MIXED_TYPE_CLASS} = {MIXED_TYPE_CLASS}()\n",
            generated,
        )

    def test_default_follows_the_validators_when_there_are_any(self):
        generated = self.builder_with_linked_types(
            [PERSON_TYPE, ORGANIZATION_TYPE], minItems=1
        ).translate()
        self.assertRegex(
            generated,
            rf"(?m)^        {PROPERTY_NAME} \(1,:\) {MIXED_TYPE_CLASS} \.\.\.\n"
            rf"            \{{[^\n]*\}} = {MIXED_TYPE_CLASS}\(\)$",
        )

    def test_single_type_property_has_no_default(self):
        generated = self.builder_with_linked_types([PERSON_TYPE]).translate()
        self.assertRegex(
            generated,
            rf"(?m)^        {PROPERTY_NAME} \(1,:\) openminds.core.actors.Person[^=]*$",
        )
        self.assertNotIn(f"{PROPERTY_NAME} (1,:) openminds.core.actors.Person =", generated)

    def test_properties_are_set_observable(self):
        generated = self.builder_with_linked_types([PERSON_TYPE]).translate()
        self.assertIn("properties (SetObservable)", generated)

    def test_mixed_type_class_defines_its_own_empty(self):
        builder = self.builder_with_linked_types([PERSON_TYPE, ORGANIZATION_TYPE])
        builder.build()
        mixed_type_file = os.path.join(
            self.output_directory, "target", VERSION, "mixedtypes",
            "+openminds", "+internal", "+mixedtype", "+sample", "Author.m")
        self.assertTrue(os.path.isfile(mixed_type_file), "mixed type class not generated")
        with open(mixed_type_file, encoding="utf-8") as generated_file:
            generated = generated_file.read()
        self.assertIn("function obj = empty(varargin)", generated)
        self.assertIn(f"obj = {MIXED_TYPE_CLASS}();", generated)


if __name__ == "__main__":
    unittest.main()
