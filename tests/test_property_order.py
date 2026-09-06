"""Tests for the order in which properties are written into a generated class."""

import json
import os
import shutil
import tempfile
import unittest

from pipeline.translator import MATLABSchemaBuilder, _property_name_sort_key
from pipeline.utils import initialise_jinja_templates

VERSION = "v9.0"
TYPE_PREFIX = "https://openminds.ebrains.eu/core/"
VOCAB_PREFIX = "https://openminds.ebrains.eu/vocab/"


def schema_property_item(property_name):
    """A (key, value) pair as it appears in a parsed schema's properties."""
    return (
        f"{VOCAB_PREFIX}{property_name}",
        {"type": "string", "description": f"Description of {property_name}."},
    )


class PropertyNameSortKeyTest(unittest.TestCase):
    """The key is applied to full property IRIs, not to bare property names."""

    def sorted_names(self, property_names):
        items = [schema_property_item(name) for name in property_names]
        return [
            full_name.rsplit("/", 1)[-1]
            for full_name, _ in sorted(items, key=_property_name_sort_key)
        ]

    def test_naming_property_comes_before_alphabetically_earlier_ones(self):
        self.assertEqual(
            self.sorted_names(["zeta", "name", "alpha"]), ["name", "alpha", "zeta"]
        )

    def test_naming_properties_keep_their_configured_precedence(self):
        self.assertEqual(
            self.sorted_names(["lookupLabel", "shortName", "fullName", "name"]),
            ["name", "fullName", "shortName", "lookupLabel"],
        )

    def test_remaining_properties_stay_alphabetical(self):
        self.assertEqual(
            self.sorted_names(["gamma", "alpha", "beta"]), ["alpha", "beta", "gamma"]
        )


class GeneratedPropertyOrderTest(unittest.TestCase):
    """The generated classes are alphabetical, so that the priority order in
    _property_name_sort_key cannot be adopted without a deliberate change."""

    def setUp(self):
        self.root = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.root, ignore_errors=True)
        self.schema_folder = os.path.join(self.root, VERSION, "core")
        os.makedirs(self.schema_folder)

        self.output_directory = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.output_directory, ignore_errors=True)
        self.addCleanup(os.chdir, os.getcwd())

    def generated_property_order(self, property_names):
        short_name = "sample"
        schema_type = f"{TYPE_PREFIX}{short_name}"
        payload = {
            "_type": schema_type,
            "properties": dict(schema_property_item(name) for name in property_names),
            "required": [],
        }
        path = os.path.join(self.schema_folder, f"{short_name}.schema.omi.json")
        with open(path, "w", encoding="utf-8") as schema_file:
            json.dump(payload, schema_file)

        os.chdir(self.output_directory)
        builder = MATLABSchemaBuilder(
            path,
            self.root,
            {schema_type: "openminds.core.Sample"},
            initialise_jinja_templates(),
        )
        generated = builder.translate()

        # The property block declares one property per non-comment line.
        block = generated.split("properties")[1]
        return [
            line.split()[0]
            for line in block.splitlines()
            if line.startswith("        ") and not line.strip().startswith("%")
            and line.strip()
        ]

    def test_properties_are_alphabetical_not_led_by_the_naming_property(self):
        self.assertEqual(
            self.generated_property_order(["zeta", "name", "alpha"]),
            ["alpha", "name", "zeta"],
        )


if __name__ == "__main__":
    unittest.main()
