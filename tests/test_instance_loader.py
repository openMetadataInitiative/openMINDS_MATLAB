"""Tests for locating the instance files that belong to a controlled term."""

import os
import shutil
import tempfile
import unittest

from pipeline.utils import InstanceLoader, _find_all_instances

VERSION = "v9.0"


class InstanceLoaderTest(unittest.TestCase):

    def setUp(self):
        # Resolved, because the loader resolves the working directory and a
        # temporary folder reaches it through a symlink on some platforms.
        self.root = os.path.realpath(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, self.root, ignore_errors=True)

        # The loader resolves its sources against the working directory.
        self.addCleanup(os.chdir, os.getcwd())
        os.chdir(self.root)

        # The walk of a version is cached, so a test must not see the tree an
        # earlier one built at the same path.
        _find_all_instances.cache_clear()
        self.addCleanup(_find_all_instances.cache_clear)

        self.instances_root = os.path.join(
            self.root, "_sources", "openMINDS_instances", "instances", VERSION
        )
        self.loader = InstanceLoader()

    def write_instance(self, *path_parts):
        """Create an instance file at the given path below the version folder."""
        path = os.path.join(self.instances_root, *path_parts)
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w", encoding="utf-8") as instance_file:
            instance_file.write("{}")
        return path

    def test_finds_the_instances_of_one_schema(self):
        expected = [
            self.write_instance("terminologies", "ageCategory", "adult.jsonld"),
            self.write_instance("terminologies", "ageCategory", "juvenile.jsonld"),
        ]
        self.write_instance("terminologies", "species", "mus musculus.jsonld")

        self.assertEqual(
            sorted(self.loader.find_instances(VERSION, "ageCategory")), sorted(expected)
        )

    def test_a_folder_whose_name_merely_starts_the_same_is_not_a_match(self):
        self.write_instance("terminologies", "ageCategoryExtra", "adult.jsonld")

        self.assertEqual(self.loader.find_instances(VERSION, "ageCategory"), [])

    def test_the_instance_folder_is_found_at_any_depth(self):
        expected = self.write_instance(
            "terminologies", "nested", "deeper", "ageCategory", "adult.jsonld"
        )

        self.assertEqual(self.loader.find_instances(VERSION, "ageCategory"), [expected])

    def test_every_instance_is_returned_when_no_schema_is_named(self):
        expected = [
            self.write_instance("terminologies", "ageCategory", "adult.jsonld"),
            self.write_instance("terminologies", "species", "mus musculus.jsonld"),
        ]

        self.assertEqual(sorted(self.loader.find_instances(VERSION)), sorted(expected))

    def test_a_version_without_instances_yields_nothing(self):
        self.write_instance("terminologies", "ageCategory", "adult.jsonld")

        self.assertEqual(self.loader.find_instances("v8.0", "ageCategory"), [])

    def test_collection_reports_the_instance_names(self):
        self.write_instance("terminologies", "ageCategory", "adult.jsonld")
        self.write_instance("terminologies", "ageCategory", "juvenile.jsonld")

        self.assertEqual(
            sorted(self.loader.get_instance_collection(VERSION, "ageCategory")),
            ["adult", "juvenile"],
        )


if __name__ == "__main__":
    unittest.main()
