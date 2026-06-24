"""Core conversion logic for csv2json."""

import json
from pathlib import Path

import pandas as pd


def convert_csv_to_json(input_path, output_path, indent=2):
    """Read a CSV file and write its contents as JSON.

    Args:
        input_path: Path to the source CSV file.
        output_path: Path for the output JSON file.
        indent: Number of spaces for JSON indentation.
    """
    df = pd.read_csv(input_path)
    records = df.to_dict(orient="records")

    output = Path(output_path)
    output.write_text(json.dumps(records, indent=indent, default=str))
