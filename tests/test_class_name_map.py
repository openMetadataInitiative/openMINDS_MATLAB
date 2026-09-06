"""Tests for how a type name used by two schemas is reported.

openMINDS type names are expected to be unique across modules, so a name
declared twice is a model problem the build should surface rather than
silently resolve to whichever schema comes first.
"""

import contextlib
import glob
import io
import json
import os
import shutil
import tempfile
import unittest

from pipeline.utils import _get_template_variables, get_class_name_map

VERSION = "v9.0"


class SchemaLoaderStub:
    """Stands in for SchemaLoader, which reads a fixed _sources location."""

    def __init__(self, schemas_sources):
        self.schemas_sources = schemas_sources

    def find_schemas(self, version):
        return glob.glob(
            os.path.join(self.schemas_sources, version, "**", "*.schema.omi.json"),
            recursive=True,
        )


class DuplicateTypeNameTestCase(unittest.TestCase):

    def setUp(self):
        self.root = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.root, ignore_errors=True)
        self.loader = SchemaLoaderStub(self.root)

    def write_schema(self, module, short_name, group=None):
        parts = [self.root, VERSION, module]
        if group:
            parts.append(group)
        folder = os.path.join(*parts)
        os.makedirs(folder, exist_ok=True)

        path = os.path.join(folder, f"{short_name}.schema.omi.json")
        payload = {
            "_type": f"https://openminds.ebrains.eu/{module}/{short_name}",
            "properties": {},
            "required": [],
        }
        with open(path, "w", encoding="utf-8") as schema_file:
            json.dump(payload, schema_file)
        return path

    def class_name_map(self):
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            mapping = get_class_name_map(self.loader, VERSION)
        return mapping, output.getvalue()

    def types_enumeration(self):
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            variables = _get_template_variables(
                "Types", sorted(self.loader.find_schemas(VERSION)), self.root
            )
        return variables["types"], output.getvalue()


class ClassNameMapTest(DuplicateTypeNameTestCase):

    def test_warns_and_names_both_schemas_when_a_type_name_is_reused(self):
        self.write_schema("controlledTerms", "behavioralTask")
        self.write_schema("core", "behavioralTask", group="research")

        mapping, warnings = self.class_name_map()

        self.assertIn("BehavioralTask", warnings)
        self.assertIn(VERSION, warnings)
        self.assertIn("controlledTerms", warnings)
        self.assertIn(os.path.join("core", "research"), warnings)
        # The winning entry is still reported, so the message says what a
        # lookup by name actually resolves to.
        self.assertIn(mapping["BehavioralTask"], warnings)

    def test_unique_type_names_produce_no_warning(self):
        self.write_schema("controlledTerms", "behavioralTask")
        self.write_schema("core", "subject", group="research")

        mapping, warnings = self.class_name_map()

        self.assertEqual(warnings, "")
        self.assertEqual(
            mapping["BehavioralTask"], "openminds.controlledterms.BehavioralTask"
        )
        self.assertEqual(mapping["Subject"], "openminds.core.research.Subject")

    def test_the_type_iri_of_each_schema_still_resolves(self):
        # Only the lookup by bare name is ambiguous; each schema keeps its own
        # entry under its fully qualified type.
        self.write_schema("controlledTerms", "behavioralTask")
        self.write_schema("core", "behavioralTask", group="research")

        mapping, _ = self.class_name_map()

        self.assertEqual(
            mapping["https://openminds.ebrains.eu/controlledTerms/behavioralTask"],
            "openminds.controlledterms.BehavioralTask",
        )
        self.assertEqual(
            mapping["https://openminds.ebrains.eu/core/behavioralTask"],
            "openminds.core.research.BehavioralTask",
        )


class TypesEnumerationTest(DuplicateTypeNameTestCase):

    def test_warns_about_the_class_left_out_of_the_enumeration(self):
        self.write_schema("controlledTerms", "behavioralTask")
        self.write_schema("core", "behavioralTask", group="research")

        types, warnings = self.types_enumeration()

        enumerated = [entry["class_name"] for entry in types]
        self.assertEqual(len(enumerated), 1)
        self.assertIn("BehavioralTask", warnings)
        self.assertIn("left out", warnings)
        # The omitted class is the one named in the warning.
        omitted = {
            "openminds.controlledterms.BehavioralTask",
            "openminds.core.research.BehavioralTask",
        } - set(enumerated)
        self.assertIn(omitted.pop(), warnings)

    def test_unique_type_names_produce_no_warning(self):
        self.write_schema("controlledTerms", "behavioralTask")
        self.write_schema("core", "subject", group="research")

        types, warnings = self.types_enumeration()

        self.assertEqual(warnings, "")
        self.assertEqual(len(types), 2)


if __name__ == "__main__":
    unittest.main()
