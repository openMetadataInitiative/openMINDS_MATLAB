"""Tests for the size attribute a property is declared and documented with.

A MATLAB (1,1) property requires a value, so a scalar that has to map an
absent value is declared as a list and constrained to a scalar by a validator.
The documented size states the cardinality the property actually holds, which
stays (1,1) for those.
"""

import json
import os
import re
import shutil
import tempfile
import unittest

from pipeline.translator import MATLABSchemaBuilder
from pipeline.utils import initialise_jinja_templates

VERSION = "v9.0"
SCHEMA_TYPE = "https://openminds.ebrains.eu/core/sample"
VOCAB_PREFIX = "https://openminds.ebrains.eu/vocab/"

PROPERTY_NAME = "value"


class PropertySizeTest(unittest.TestCase):

    def setUp(self):
        self.root = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.root, ignore_errors=True)
        self.schema_folder = os.path.join(self.root, VERSION, "core")
        os.makedirs(self.schema_folder)

        self.output_directory = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.output_directory, ignore_errors=True)
        self.addCleanup(os.chdir, os.getcwd())

    def sizes_for(self, property_info):
        """Return the (documented, declared) size of a property of this shape."""
        payload = {
            "_type": SCHEMA_TYPE,
            "properties": {
                # A name property keeps the class out of the missing display
                # label path; only the property under test is inspected.
                f"{VOCAB_PREFIX}name": {"type": "string"},
                f"{VOCAB_PREFIX}{PROPERTY_NAME}": property_info,
            },
            "required": [],
        }
        path = os.path.join(self.schema_folder, "sample.schema.omi.json")
        with open(path, "w", encoding="utf-8") as schema_file:
            json.dump(payload, schema_file)

        os.chdir(self.output_directory)
        generated = MATLABSchemaBuilder(
            path,
            self.root,
            {SCHEMA_TYPE: "openminds.core.Sample"},
            initialise_jinja_templates(),
        ).translate()

        documented = re.search(
            rf"(?m)^%\s+{PROPERTY_NAME}\s+: (\(1,[:1]\)) ", generated
        )
        declared = re.search(rf"(?m)^        {PROPERTY_NAME} (\(1,[:1]\)) ", generated)
        self.assertIsNotNone(documented, f"no docstring line for {PROPERTY_NAME}")
        self.assertIsNotNone(declared, f"no declaration for {PROPERTY_NAME}")
        return documented.group(1), declared.group(1)

    def assertScalarAllowingEmpty(self, property_info):
        documented, declared = self.sizes_for(property_info)
        self.assertEqual(documented, "(1,1)", "a scalar must be documented as (1,1)")
        self.assertEqual(declared, "(1,:)", "a scalar mapping a null must allow empty")

    def test_number_constrained_to_a_range_is_a_scalar_allowing_empty(self):
        self.assertScalarAllowingEmpty(
            {"type": "number", "minimum": 0, "maximum": 1}
        )

    def test_number_with_an_exclusive_bound_is_a_scalar_allowing_empty(self):
        self.assertScalarAllowingEmpty(
            {"type": "number", "exclusiveMinimum": 0, "exclusiveMaximum": 1}
        )

    def test_integer_is_a_scalar_allowing_empty(self):
        self.assertScalarAllowingEmpty({"type": "integer"})

    def test_date_is_a_scalar_allowing_empty(self):
        self.assertScalarAllowingEmpty({"type": "string", "_formats": ["date"]})

    def test_unconstrained_number_is_a_plain_scalar(self):
        # Without a range there is no validator to constrain a list back to a
        # scalar, so the declared size carries the constraint itself.
        self.assertEqual(self.sizes_for({"type": "number"}), ("(1,1)", "(1,1)"))

    def test_string_is_a_plain_scalar(self):
        self.assertEqual(self.sizes_for({"type": "string"}), ("(1,1)", "(1,1)"))

    def test_array_is_a_list_in_both_places(self):
        self.assertEqual(
            self.sizes_for({"type": "array", "items": {"type": "string"}}),
            ("(1,:)", "(1,:)"),
        )


if __name__ == "__main__":
    unittest.main()
