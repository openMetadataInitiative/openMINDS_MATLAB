"""Tests for the per-version controlled term base class generation."""

import json
import os
import shutil
import tempfile
import unittest

from pipeline.translator import (
    _find_controlled_term_schema,
    _get_controlled_term_base_properties,
    save_controlled_term_base_class,
)
from pipeline.utils import initialise_jinja_templates

VERSION = "v9.0"


def controlled_term_schema(short_name, property_names):
    """A minimal controlled term schema declaring the given string properties."""
    return {
        "_type": f"https://openminds.ebrains.eu/controlledTerms/{short_name}",
        "properties": {
            f"https://openminds.ebrains.eu/vocab/{name}": {
                "type": "string",
                "description": f"Description of {name}.",
            }
            for name in property_names
        },
        "required": [],
    }


class ControlledTermBaseTestCase(unittest.TestCase):

    def setUp(self):
        self.root = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.root, ignore_errors=True)
        self.schema_folder = os.path.join(self.root, VERSION, "controlledTerms")
        os.makedirs(self.schema_folder)

        # The working directory is where the build writes its target folder.
        self.original_directory = os.getcwd()
        self.output_directory = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.output_directory, ignore_errors=True)
        self.addCleanup(os.chdir, self.original_directory)

        self.class_name_map = {}

    def write_schema(self, short_name, property_names):
        path = os.path.join(self.schema_folder, f"{short_name}.schema.omi.json")
        payload = controlled_term_schema(short_name, property_names)
        with open(path, "w", encoding="utf-8") as schema_file:
            json.dump(payload, schema_file)
        # The builder resolves every schema type through the class name map that
        # build.py assembles for the version.
        self.class_name_map[payload["_type"]] = (
            f"openminds.controlledterms.{short_name[0].upper()}{short_name[1:]}"
        )
        return path


class BasePropertySetTest(ControlledTermBaseTestCase):

    def test_picks_the_property_set_shared_by_most_schemas(self):
        shared = ["definition", "name"]
        self.write_schema("alpha", shared)
        self.write_schema("beta", shared)
        self.write_schema("gamma", shared + ["extraProperty"])
        self.assertEqual(
            _get_controlled_term_base_properties(self.root, VERSION), set(shared)
        )

    def test_returns_empty_set_when_the_version_has_no_controlled_terms(self):
        self.assertEqual(_get_controlled_term_base_properties(self.root, "v8.0"), set())


class FindControlledTermSchemaTest(ControlledTermBaseTestCase):

    def test_returns_the_schema_declaring_exactly_the_base_properties(self):
        self.write_schema("gamma", ["definition", "name", "extraProperty"])
        expected = self.write_schema("alpha", ["definition", "name"])
        self.assertEqual(
            _find_controlled_term_schema(self.root, VERSION, {"definition", "name"}),
            expected,
        )

    def test_raises_when_no_schema_declares_exactly_that_set(self):
        self.write_schema("alpha", ["definition", "name", "extraProperty"])
        with self.assertRaisesRegex(ValueError, "No controlled term schema"):
            _find_controlled_term_schema(self.root, VERSION, {"definition", "name"})


class SaveControlledTermBaseClassTest(ControlledTermBaseTestCase):

    def generate(self):
        os.chdir(self.output_directory)
        return save_controlled_term_base_class(
            VERSION, self.root, self.class_name_map, initialise_jinja_templates()
        )

    def test_writes_the_base_class_into_the_version_folder(self):
        self.write_schema("alpha", ["definition", "name"])
        self.write_schema("beta", ["definition", "name"])
        path = self.generate()
        self.assertEqual(
            path,
            os.path.join("target", "base", VERSION, "+openminds", "+base", "ControlledTerm.m"),
        )
        self.assertTrue(os.path.isfile(os.path.join(self.output_directory, path)))

    def test_declares_the_shared_properties_and_omits_schema_specific_ones(self):
        shared = ["definition", "name"]
        self.write_schema("alpha", shared)
        self.write_schema("beta", shared)
        self.write_schema("gamma", shared + ["extraProperty"])

        with open(os.path.join(self.output_directory, self.generate()), encoding="utf-8") as f:
            generated = f.read()

        self.assertIn("classdef (Abstract) ControlledTerm < openminds.base.ControlledTermBase", generated)
        for name in shared:
            self.assertRegex(generated, rf"(?m)^        {name} \(1,1\) string$")
        self.assertNotIn("extraProperty", generated)

    def test_returns_none_when_the_version_has_no_controlled_terms(self):
        os.chdir(self.output_directory)
        self.assertIsNone(
            save_controlled_term_base_class(
                "v8.0", self.root, self.class_name_map, initialise_jinja_templates()
            )
        )


if __name__ == "__main__":
    unittest.main()
