"""Tests for locating the instance files that belong to a controlled term."""

import json
import os
import shutil
import tempfile
import unittest

from pipeline.utils import InstanceLoader, _find_all_instances, _find_instance_types

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
        _find_instance_types.cache_clear()
        self.addCleanup(_find_instance_types.cache_clear)

        self.instances_root = os.path.join(
            self.root, "_sources", "openMINDS_instances", "instances", VERSION
        )
        self.loader = InstanceLoader()

    def write_instance(self, *path_parts, type_iri=None):
        """Create an instance file at the given path below the version folder.

        The document declares the given type, or nothing when no type is given.
        """
        path = os.path.join(self.instances_root, *path_parts)
        os.makedirs(os.path.dirname(path), exist_ok=True)
        document = {} if type_iri is None else {"@type": type_iri}
        with open(path, "w", encoding="utf-8") as instance_file:
            json.dump(document, instance_file)
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

    def test_the_types_with_instances_are_read_from_the_documents(self):
        # Both IRI forms the library uses, a folder whose plural name does not
        # match its type, a nested folder and a controlled term.
        self.write_instance(
            "brainAtlases", "aal.jsonld",
            type_iri="https://openminds.om-i.org/types/AnatomicalAtlas",
        )
        self.write_instance(
            "brainAtlasVersions", "AAL1", "aal1.jsonld",
            type_iri="https://openminds.ebrains.eu/sands/BrainAtlasVersion",
        )
        self.write_instance(
            "accessibilities", "free.jsonld",
            type_iri="https://openminds.om-i.org/types/Accessibility",
        )
        self.write_instance(
            "terminologies", "ageCategory", "adult.jsonld",
            type_iri="https://openminds.om-i.org/types/AgeCategory",
        )

        self.assertEqual(
            self.loader.get_types_with_instances(VERSION),
            {"AnatomicalAtlas", "BrainAtlasVersion", "Accessibility", "AgeCategory"},
        )

    def test_one_document_per_folder_types_the_folder(self):
        # The second document of a folder is never opened, so a document
        # without a type there does not fail the read.
        self.write_instance(
            "licenses", "a.jsonld", type_iri="https://openminds.om-i.org/types/License"
        )
        self.write_instance("licenses", "b.jsonld")

        self.assertEqual(self.loader.get_types_with_instances(VERSION), {"License"})

    def test_a_folder_without_instance_files_contributes_no_type(self):
        # Types come from the instance files, so a folder holding none, or only
        # other files, is as good as absent.
        os.makedirs(os.path.join(self.instances_root, "singleColors"))
        readme = os.path.join(self.instances_root, "licenses", "README.md")
        os.makedirs(os.path.dirname(readme))
        with open(readme, "w", encoding="utf-8") as readme_file:
            readme_file.write("no instances here")

        self.assertEqual(self.loader.get_types_with_instances(VERSION), frozenset())

    def test_a_version_without_instances_has_no_types(self):
        self.write_instance(
            "licenses", "a.jsonld", type_iri="https://openminds.om-i.org/types/License"
        )

        self.assertEqual(self.loader.get_types_with_instances("v8.0"), frozenset())

    def test_an_instance_without_a_type_is_reported(self):
        path = self.write_instance("licenses", "a.jsonld")

        with self.assertRaises(ValueError) as context:
            self.loader.get_types_with_instances(VERSION)
        self.assertIn(path, str(context.exception))


if __name__ == "__main__":
    unittest.main()
