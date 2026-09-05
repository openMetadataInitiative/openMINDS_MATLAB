"""Tests for the per-version controlled term abstract class generation."""

import json
import os
import shutil
import tempfile
import unittest

from pipeline.translator import (
    MATLABSchemaBuilder,
    _find_controlled_term_schema,
    _get_controlled_term_base_properties,
    _get_controlled_term_property_sets,
    save_controlled_term_base_class,
)
from pipeline.utils import initialise_jinja_templates

VERSION = "v9.0"
TYPE_PREFIX = "https://openminds.ebrains.eu/controlledTerms/"


def controlled_term_schema(short_name, property_names, linked_properties=None):
    """A minimal controlled term schema declaring the given string properties.

    linked_properties maps a property name to the short names of the
    controlled term types it may link to.
    """
    properties = {
        f"https://openminds.ebrains.eu/vocab/{name}": {
            "type": "string",
            "description": f"Description of {name}.",
        }
        for name in property_names
    }
    for name, linked_type_names in (linked_properties or {}).items():
        properties[f"https://openminds.ebrains.eu/vocab/{name}"] = {
            "_linkedTypes": [f"{TYPE_PREFIX}{type_name}" for type_name in linked_type_names],
            "description": f"Description of {name}.",
        }
    return {
        "_type": f"{TYPE_PREFIX}{short_name}",
        "properties": properties,
        "required": [],
    }


class ControlledTermBaseTestCase(unittest.TestCase):

    def setUp(self):
        self.root = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.root, ignore_errors=True)
        self.schema_folder = os.path.join(self.root, VERSION, "controlledTerms")
        os.makedirs(self.schema_folder)

        # The controlled term schemas of a version are read once and cached,
        # so a test must not see what an earlier one wrote.
        _get_controlled_term_property_sets.cache_clear()
        self.addCleanup(_get_controlled_term_property_sets.cache_clear)

        # The working directory is where the build writes its target folder.
        self.original_directory = os.getcwd()
        self.output_directory = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.output_directory, ignore_errors=True)
        self.addCleanup(os.chdir, self.original_directory)

        self.class_name_map = {}

    def write_schema(self, short_name, property_names, linked_properties=None):
        path = os.path.join(self.schema_folder, f"{short_name}.schema.omi.json")
        payload = controlled_term_schema(short_name, property_names, linked_properties)
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

    def generated_text(self):
        with open(os.path.join(self.output_directory, self.generate()), encoding="utf-8") as f:
            return f.read()

    def test_extends_the_abstract_class_of_its_own_module(self):
        # The concrete terms name the generated class in their own module, not
        # the hand-written machinery it extends.
        self.write_schema("alpha", ["definition", "name"])
        os.chdir(self.output_directory)
        generated = MATLABSchemaBuilder(
            os.path.join(self.schema_folder, "alpha.schema.omi.json"),
            self.root,
            self.class_name_map,
            initialise_jinja_templates(),
        ).translate()
        self.assertIn(
            "classdef Alpha < openminds.controlledterms.ControlledTerm", generated)

    def test_writes_the_abstract_class_beside_the_terms_of_its_module(self):
        self.write_schema("alpha", ["definition", "name"])
        self.write_schema("beta", ["definition", "name"])
        path = self.generate()
        self.assertEqual(
            path,
            os.path.join(
                "target", VERSION, "types", "+openminds", "+controlledterms", "ControlledTerm.m"),
        )
        self.assertTrue(os.path.isfile(os.path.join(self.output_directory, path)))

    def test_declares_the_shared_properties_and_omits_schema_specific_ones(self):
        shared = ["definition", "name"]
        self.write_schema("alpha", shared)
        self.write_schema("beta", shared)
        self.write_schema("gamma", shared + ["extraProperty"])

        generated = self.generated_text()

        self.assertIn("classdef (Abstract) ControlledTerm < openminds.base.ControlledTerm", generated)
        for name in shared:
            self.assertRegex(generated, rf"(?m)^        {name} \(1,1\) string$")
        self.assertNotIn("extraProperty", generated)

    def test_constructor_accepts_any_name_value_pair(self):
        # A subclass forwards all of its properties to this constructor, so it
        # must not restrict the accepted names to the properties declared here.
        self.write_schema("alpha", ["definition", "name"])
        generated = self.generated_text()
        self.assertIn("function obj = ControlledTerm(instanceSpec, name, value)", generated)
        self.assertIn("arguments (Repeating)", generated)
        self.assertNotIn("propValues.?", generated)

    def test_leaves_the_property_maps_to_the_subclasses(self):
        # Node declares the maps abstract; a subclass with linked properties
        # must be free to define them, which MATLAB forbids once a superclass
        # has.
        self.write_schema("alpha", ["definition", "name"])
        generated = self.generated_text()
        self.assertNotIn("LINKED_PROPERTIES", generated)
        self.assertNotIn("EMBEDDED_PROPERTIES", generated)

    def test_returns_none_when_the_version_has_no_controlled_terms(self):
        os.chdir(self.output_directory)
        self.assertIsNone(
            save_controlled_term_base_class(
                "v8.0", self.root, self.class_name_map, initialise_jinja_templates()
            )
        )


class ControlledTermClassTest(ControlledTermBaseTestCase):
    """The generated controlled term classes themselves."""

    def setUp(self):
        super().setUp()
        self.shared = ["definition", "name"]
        self.write_schema("alpha", self.shared)
        self.write_schema("beta", self.shared)

    def translate(self, schema_path):
        os.chdir(self.output_directory)
        builder = MATLABSchemaBuilder(
            schema_path, self.root, self.class_name_map, initialise_jinja_templates()
        )
        return builder.translate()

    def test_every_class_defines_the_property_maps_node_declares_abstract(self):
        generated = self.translate(os.path.join(self.schema_folder, "alpha.schema.omi.json"))
        self.assertRegex(generated, r"LINKED_PROPERTIES = struct\(\.\.\.\n\s*\)")
        self.assertRegex(generated, r"EMBEDDED_PROPERTIES = struct\(\.\.\.\n\s*\)")

    def test_linked_property_is_declared_and_mapped(self):
        path = self.write_schema(
            "gamma", self.shared, linked_properties={"linkedTerm": ["alpha"]}
        )
        generated = self.translate(path)
        self.assertRegex(
            generated,
            r"(?m)^        linkedTerm \(1,:\) openminds\.controlledterms\.Alpha \.\.\.$",
        )
        self.assertIn(
            "'linkedTerm', \"openminds.controlledterms.Alpha\"", generated
        )
        for name in self.shared:
            # Shared properties come from the base class.
            self.assertNotRegex(generated, rf"(?m)^        {name} \(1,1\) string$")

    def test_constructor_forwards_all_properties_to_the_abstract_class(self):
        path = self.write_schema(
            "gamma", self.shared, linked_properties={"linkedTerm": ["alpha"]}
        )
        generated = self.translate(path)
        self.assertIn("propValues.?openminds.controlledterms.Gamma", generated)
        self.assertIn(
            "obj@openminds.controlledterms.ControlledTerm(instanceSpec, propValues{:})",
            generated,
        )

    def test_required_stays_in_the_base_class(self):
        generated = self.translate(os.path.join(self.schema_folder, "alpha.schema.omi.json"))
        self.assertNotIn("Required", generated)


if __name__ == "__main__":
    unittest.main()
