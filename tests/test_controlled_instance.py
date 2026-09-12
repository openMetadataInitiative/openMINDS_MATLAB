"""Tests for which generated classes take the controlled instance mixin.

The mixin gives a class fromName and listInstances, resolved through the
instance library at run time. A class takes it when the library of its own
model version holds instances of its type, which the documents declare.
"""

import json
import os
import shutil
import tempfile
import unittest

from pipeline.translator import MATLABSchemaBuilder, _get_controlled_term_property_sets
from pipeline.utils import (
    initialise_jinja_templates,
    _find_all_instances,
    _find_instance_types,
)

VERSION = "v9.0"
TYPE_PREFIX = "https://openminds.om-i.org/types/"
VOCAB_PREFIX = "https://openminds.ebrains.eu/vocab/"
MIXIN = "openminds.internal.mixin.HasControlledInstance"


class ControlledInstanceMixinTest(unittest.TestCase):

    def setUp(self):
        self.schema_root = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.schema_root, ignore_errors=True)

        # The instance loader resolves its sources against the working
        # directory, which is also where the build writes. Resolved, because a
        # temporary folder reaches it through a symlink on some platforms.
        self.working_directory = os.path.realpath(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, self.working_directory, ignore_errors=True)
        self.addCleanup(os.chdir, os.getcwd())
        os.chdir(self.working_directory)

        self.instances_root = os.path.join(
            self.working_directory, "_sources", "openMINDS_instances", "instances"
        )

        # Instance and controlled term reads are cached per version, so a test
        # must not see the tree an earlier one built at the same path.
        for cached in (_find_all_instances, _find_instance_types, _get_controlled_term_property_sets):
            cached.cache_clear()
            self.addCleanup(cached.cache_clear)

    def write_schema(self, module, short_name):
        """A minimal schema of one module, with a name property for its display label."""
        folder = os.path.join(self.schema_root, VERSION, module)
        os.makedirs(folder, exist_ok=True)
        path = os.path.join(folder, f"{short_name}.schema.omi.json")
        payload = {
            "_type": f"{TYPE_PREFIX}{short_name[0].upper()}{short_name[1:]}",
            "properties": {
                f"{VOCAB_PREFIX}name": {"type": "string"},
                f"{VOCAB_PREFIX}definition": {"type": "string"},
            },
            "required": [],
        }
        with open(path, "w", encoding="utf-8") as schema_file:
            json.dump(payload, schema_file)
        return path

    def write_instance(self, version, folder, type_name):
        path = os.path.join(self.instances_root, version, folder, "one.jsonld")
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w", encoding="utf-8") as instance_file:
            json.dump({"@type": f"{TYPE_PREFIX}{type_name}"}, instance_file)

    def translate(self, schema_path, module, short_name):
        class_name_map = {
            f"{TYPE_PREFIX}{short_name[0].upper()}{short_name[1:]}":
                f"openminds.{module.lower()}.{short_name[0].upper()}{short_name[1:]}"
        }
        return MATLABSchemaBuilder(
            schema_path, self.schema_root, class_name_map, initialise_jinja_templates()
        ).translate()

    def test_a_type_with_instances_in_its_version_takes_the_mixin(self):
        # The folder name does not match the type: the type comes from the document.
        self.write_instance(VERSION, "brainAtlases", "AnatomicalAtlas")
        path = self.write_schema("sands", "anatomicalAtlas")

        generated = self.translate(path, "sands", "anatomicalAtlas")

        self.assertIn(f"classdef AnatomicalAtlas < openminds.Node & {MIXIN}", generated)
        self.assertIn("function instance = fromName(name)", generated)
        self.assertIn("function instanceNames = listInstances()", generated)

    def test_instances_of_another_version_do_not_count(self):
        self.write_instance("v8.0", "anatomicalAtlases", "AnatomicalAtlas")
        path = self.write_schema("sands", "anatomicalAtlas")

        generated = self.translate(path, "sands", "anatomicalAtlas")

        self.assertIn("classdef AnatomicalAtlas < openminds.Node\n", generated)
        self.assertNotIn(MIXIN, generated)

    def test_a_controlled_term_lists_its_instances_without_the_mixin(self):
        self.write_instance(VERSION, os.path.join("terminologies", "ageCategory"), "AgeCategory")
        path = self.write_schema("controlledTerms", "ageCategory")

        generated = self.translate(path, "controlledTerms", "ageCategory")

        self.assertNotIn(MIXIN, generated)
        self.assertIn('"one"', generated)


if __name__ == "__main__":
    unittest.main()
