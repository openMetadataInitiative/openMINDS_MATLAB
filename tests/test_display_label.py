"""Tests for the display label expressions generated from instanceDisplayConfig.json."""

import json
import os
import unittest
from unittest import mock

from pipeline.translator import (
    _get_display_label_method_expression,
    _qualify_property_names,
)

# Indentation the translator uses to join the lines of a multi-line expression,
# matching the indent of the getDisplayLabel body in the schema class template.
BLOCK_INDENT = "\n            "

CONFIG_PATH = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
    "pipeline",
    "instanceDisplayConfig.json",
)


def display_label_for(schema_short_name, property_names, config):
    """Generate the getDisplayLabel body for a schema against a given config."""
    with mock.patch("pipeline.translator.json.load", return_value=config):
        return _get_display_label_method_expression(schema_short_name, property_names)


class QualifyPropertyNamesTest(unittest.TestCase):

    def test_qualifies_each_property_reference(self):
        self.assertEqual(
            _qualify_property_names(
                "sprintf('%s, %s', familyName, givenName)", ["givenName", "familyName"]
            ),
            "sprintf('%s, %s', obj.familyName, obj.givenName)",
        )

    def test_leaves_unreferenced_property_alone(self):
        self.assertEqual(
            _qualify_property_names("sprintf('%s', name)", ["name", "lookupLabel"]),
            "sprintf('%s', obj.name)",
        )

    def test_qualifies_repeated_reference(self):
        self.assertEqual(
            _qualify_property_names("sprintf('%d %d', value, value)", ["value"]),
            "sprintf('%d %d', obj.value, obj.value)",
        )

    def test_does_not_qualify_short_name_inside_longer_name(self):
        # "minValue" is a substring of "minValueUnit"; a plain string replace
        # would rewrite it there too and then double-prefix it on the pass for
        # "minValueUnit", producing "obj.obj.minValueUnit".
        self.assertEqual(
            _qualify_property_names(
                "f(minValue, minValueUnit)", ["minValue", "minValueUnit"]
            ),
            "f(obj.minValue, obj.minValueUnit)",
        )

    def test_property_order_does_not_affect_result(self):
        expression = "f(minValue, maxValue, minValueUnit, maxValueUnit)"
        expected = "f(obj.minValue, obj.maxValue, obj.minValueUnit, obj.maxValueUnit)"
        shortest_first = ["minValue", "maxValue", "minValueUnit", "maxValueUnit"]
        self.assertEqual(_qualify_property_names(expression, shortest_first), expected)
        self.assertEqual(
            _qualify_property_names(expression, list(reversed(shortest_first))), expected
        )

    def test_does_not_qualify_namespace_segment_of_qualified_call(self):
        # A property name may collide with a segment of a package-qualified
        # function name; only the argument may be rewritten.
        self.assertEqual(
            _qualify_property_names("openminds.internal.unit.format(unit)", ["unit"]),
            "openminds.internal.unit.format(obj.unit)",
        )

    def test_does_not_qualify_field_of_already_qualified_reference(self):
        self.assertEqual(
            _qualify_property_names("sprintf('%s', memberOf.name)", ["name", "memberOf"]),
            "sprintf('%s', obj.memberOf.name)",
        )


class DisplayLabelMethodExpressionTest(unittest.TestCase):
    """Covers each shape a stringFormat entry can take, independently of the
    entries that happen to be configured in instanceDisplayConfig.json."""

    def test_sprintf_expression_is_assigned_to_output(self):
        config = {
            "person": {
                "propertyName": ["givenName", "familyName"],
                "stringFormat": "sprintf('%s, %s', familyName, givenName)",
            }
        }
        self.assertEqual(
            display_label_for("Person", ["givenName", "familyName"], config),
            "str = sprintf('%s, %s', obj.familyName, obj.givenName);",
        )

    def test_function_call_expression_is_assigned_to_output(self):
        # An expression need not be a sprintf call; the assignment must not
        # depend on which function the expression happens to use.
        config = {
            "someType": {
                "propertyName": ["value", "unit"],
                "stringFormat": "openminds.internal.display.format(value, unit)",
            }
        }
        self.assertEqual(
            display_label_for("SomeType", ["value", "unit"], config),
            "str = openminds.internal.display.format(obj.value, obj.unit);",
        )

    def test_expression_with_overlapping_property_names_is_qualified_once(self):
        config = {
            "someType": {
                "propertyName": ["minValue", "maxValue", "minValueUnit", "maxValueUnit"],
                "stringFormat": "f(minValue, maxValue, minValueUnit, maxValueUnit)",
            }
        }
        self.assertEqual(
            display_label_for(
                "SomeType",
                ["minValue", "maxValue", "minValueUnit", "maxValueUnit"],
                config,
            ),
            "str = f(obj.minValue, obj.maxValue, obj.minValueUnit, obj.maxValueUnit);",
        )

    def test_statement_block_is_emitted_verbatim(self):
        # A list stringFormat holds statements which assign the output variable
        # themselves; control flow lines must be emitted unchanged.
        config = {
            "quantitativeValue": {
                "propertyName": ["value", "unit"],
                "stringFormat": [
                    "if value ~= 1",
                    "    str = sprintf('%d %ss', value, unit);",
                    "else",
                    "    str = sprintf('%d %s', value, unit);",
                    "end",
                ],
            }
        }
        expected = BLOCK_INDENT.join(
            [
                "if obj.value ~= 1",
                "    str = sprintf('%d %ss', obj.value, obj.unit);",
                "else",
                "    str = sprintf('%d %s', obj.value, obj.unit);",
                "end",
            ]
        )
        self.assertEqual(
            display_label_for("QuantitativeValue", ["value", "unit"], config), expected
        )

    def test_entry_without_property_falls_back_to_placeholder(self):
        config = {"someType": {"propertyName": "", "stringFormat": ""}}
        self.assertEqual(
            display_label_for("SomeType", ["fullName"], config),
            "str = obj.createLabelForMissingLabelDefinition();",
        )

    def test_configured_property_missing_from_schema_falls_back_to_default(self):
        # Older model versions may not define the configured property.
        config = {
            "someType": {
                "propertyName": "shortName",
                "stringFormat": "sprintf('%s', shortName)",
            }
        }
        self.assertEqual(
            display_label_for("SomeType", ["lookupLabel"], config),
            "str = obj.lookupLabel;",
        )

    def test_uppercase_schema_name_matches_its_config_entry(self):
        # Schema names such as DOI are all uppercase in the config.
        config = {"DOI": {"propertyName": "identifier", "stringFormat": "sprintf('%s', identifier)"}}
        self.assertEqual(
            display_label_for("DOI", ["identifier"], config),
            "str = sprintf('%s', obj.identifier);",
        )


class DefaultDisplayLabelTest(unittest.TestCase):

    def test_unconfigured_schema_uses_default_property_precedence(self):
        for property_names, expected in [
            (["lookupLabel", "fullName", "identifier", "name"], "str = obj.lookupLabel;"),
            (["fullName", "identifier", "name"], "str = obj.fullName;"),
            (["identifier", "name"], "str = obj.identifier;"),
            (["name"], "str = obj.name;"),
        ]:
            with self.subTest(property_names=property_names):
                self.assertEqual(
                    display_label_for("Unconfigured", property_names, {}), expected
                )

    def test_unconfigured_schema_without_usable_property_falls_back_to_placeholder(self):
        self.assertEqual(
            display_label_for("Unconfigured", ["value"], {}),
            "str = obj.createLabelForMissingLabelDefinition();",
        )


class ShippedConfigTest(unittest.TestCase):
    """Guards the checked-in config against entries the translator cannot use."""

    @classmethod
    def setUpClass(cls):
        with open(CONFIG_PATH, encoding="utf-8") as config_file:
            cls.config = json.load(config_file)

    def test_every_configured_entry_assigns_the_output_variable(self):
        for schema_name, entry in self.config.items():
            property_names = entry["propertyName"]
            if not property_names:
                continue
            if not isinstance(property_names, list):
                property_names = [property_names]
            with self.subTest(schema=schema_name):
                expression = display_label_for(
                    schema_name, property_names, self.config
                )
                self.assertRegex(
                    expression,
                    r"(^|\n)\s*str\s*=",
                    f"'{schema_name}' generates a getDisplayLabel that never assigns str",
                )

    def test_no_configured_entry_double_qualifies_a_property(self):
        for schema_name, entry in self.config.items():
            property_names = entry["propertyName"]
            if not property_names:
                continue
            if not isinstance(property_names, list):
                property_names = [property_names]
            with self.subTest(schema=schema_name):
                self.assertNotIn(
                    "obj.obj.", display_label_for(schema_name, property_names, self.config)
                )


if __name__ == "__main__":
    unittest.main()
