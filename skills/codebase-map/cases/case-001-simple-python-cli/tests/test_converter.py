"""Tests for the csv2json converter module."""

import json
from pathlib import Path

from csv2json.converter import convert_csv_to_json


def test_convert_basic(tmp_path):
    """Convert a simple CSV and verify JSON output."""
    csv_file = tmp_path / "data.csv"
    csv_file.write_text("name,age\nAlice,30\nBob,25\n")

    json_file = tmp_path / "data.json"
    convert_csv_to_json(str(csv_file), str(json_file))

    result = json.loads(json_file.read_text())
    assert len(result) == 2
    assert result[0]["name"] == "Alice"
    assert result[1]["age"] == 25


def test_convert_custom_indent(tmp_path):
    """Verify that the indent option is respected."""
    csv_file = tmp_path / "data.csv"
    csv_file.write_text("x,y\n1,2\n")

    json_file = tmp_path / "data.json"
    convert_csv_to_json(str(csv_file), str(json_file), indent=4)

    raw = json_file.read_text()
    # Four-space indent means lines should start with "    "
    assert "    " in raw
