# csv2json

A lightweight CLI tool for converting CSV files to JSON format.

## Installation

```bash
pip install csv2json
```

Or install from source:

```bash
pip install -e .
```

## Usage

Convert a CSV file to JSON:

```bash
csv2json convert input.csv output.json
```

Specify custom indentation:

```bash
csv2json convert input.csv output.json --indent 4
```

## Features

- Reads CSV files using pandas for robust parsing
- Outputs well-formatted JSON with configurable indentation
- Handles common CSV edge cases (quoted fields, varied delimiters)

## Development

Install dev dependencies:

```bash
pip install -e ".[dev]"
```

Run tests:

```bash
pytest
```

Lint:

```bash
ruff check src/ tests/
```

## Built With

- [Click](https://click.palletsprojects.com/) -- CLI framework
- [pandas](https://pandas.pydata.org/) -- CSV parsing

## License

MIT
