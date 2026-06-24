"""CLI entry point for csv2json."""

import click

from csv2json.converter import convert_csv_to_json


@click.group()
@click.version_option()
def cli():
    """Convert CSV files to JSON format."""


@cli.command()
@click.argument("input_file", type=click.Path(exists=True))
@click.argument("output_file", type=click.Path())
@click.option("--indent", default=2, help="JSON indentation level.")
def convert(input_file, output_file, indent):
    """Convert a CSV file to JSON.

    INPUT_FILE is the path to the source CSV file.
    OUTPUT_FILE is the path for the resulting JSON file.
    """
    convert_csv_to_json(input_file, output_file, indent=indent)
    click.echo(f"Converted {input_file} -> {output_file}")


if __name__ == "__main__":
    cli()
