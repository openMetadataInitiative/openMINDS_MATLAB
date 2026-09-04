"""Tests for splitting a schema source path into its openMINDS parts."""

import os
import unittest

from pipeline.utils import (
    SCHEMA_FILE_EXTENSION,
    _get_matlab_class_name,
    namespace_name,
    parse_schema_file_path,
)

ROOT = os.path.join("some", "checkout", "_sources", "openMINDS", "schemas")


def schema_path(*path_parts):
    """An absolute-style schema path built with the platform separator."""
    last = path_parts[-1] + SCHEMA_FILE_EXTENSION
    return os.path.join(ROOT, *path_parts[:-1], last)


class ParseSchemaFilePathTest(unittest.TestCase):

    def test_splits_a_path_that_has_a_group(self):
        parsed = parse_schema_file_path(
            schema_path("v4.0", "core", "actors", "person"), ROOT
        )
        self.assertEqual(parsed["version"], "v4.0")
        self.assertEqual(parsed["module_name"], "core")
        self.assertEqual(parsed["group_name"], "actors")
        self.assertEqual(parsed["file_name"], "person")
        self.assertEqual(parsed["type_name"], "Person")

    def test_splits_a_path_that_has_no_group(self):
        parsed = parse_schema_file_path(
            schema_path("v4.0", "controlledTerms", "ageCategory"), ROOT
        )
        self.assertIsNone(parsed["group_name"])
        self.assertEqual(parsed["module_name"], "controlledTerms")
        self.assertEqual(parsed["type_name"], "AgeCategory")

    def test_keeps_the_file_name_as_written(self):
        # The instances of a controlled term live in a folder named exactly
        # like the schema file, so its case has to survive parsing.
        parsed = parse_schema_file_path(
            schema_path("v4.0", "controlledTerms", "UBERONParcellation"), ROOT
        )
        self.assertEqual(parsed["file_name"], "UBERONParcellation")
        self.assertEqual(parsed["type_name"], "UBERONParcellation")

    def test_keeps_the_group_as_written(self):
        # The manifest reports the group as the model spells it; sanitizing
        # happens only where a MATLAB identifier is needed.
        parsed = parse_schema_file_path(
            schema_path("v4.0", "SANDS", "non-atlas", "customAnnotation"), ROOT
        )
        self.assertEqual(parsed["group_name"], "non-atlas")


class NamespaceNameTest(unittest.TestCase):

    def test_lowercases_a_module_name(self):
        self.assertEqual(namespace_name("SANDS"), "sands")
        self.assertEqual(namespace_name("controlledTerms"), "controlledterms")

    def test_removes_characters_that_a_matlab_identifier_cannot_hold(self):
        self.assertEqual(namespace_name("non-atlas"), "nonatlas")


class MatlabClassNameTest(unittest.TestCase):

    def test_class_name_for_a_schema_in_a_group(self):
        self.assertEqual(
            _get_matlab_class_name(
                parse_schema_file_path(
                    schema_path("v4.0", "core", "actors", "person"), ROOT
                )
            ),
            "openminds.core.actors.Person",
        )

    def test_class_name_for_a_schema_without_a_group(self):
        self.assertEqual(
            _get_matlab_class_name(
                parse_schema_file_path(
                    schema_path("v4.0", "controlledTerms", "ageCategory"), ROOT
                )
            ),
            "openminds.controlledterms.AgeCategory",
        )

    def test_class_name_sanitizes_the_group(self):
        self.assertEqual(
            _get_matlab_class_name(
                parse_schema_file_path(
                    schema_path("v4.0", "SANDS", "non-atlas", "customAnnotation"), ROOT
                )
            ),
            "openminds.sands.nonatlas.CustomAnnotation",
        )


if __name__ == "__main__":
    unittest.main()
