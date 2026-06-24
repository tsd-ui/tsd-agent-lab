# configctl

A command-line tool for parsing, validating, and converting configuration files across TOML, YAML, and JSON formats.

## Workspace Layout

This is a Cargo workspace with two crates:

- **`crates/config-core`** — Shared library providing format detection, parsing, and schema validation for configuration files.
- **`crates/configctl`** — CLI binary that exposes the library's capabilities as user-facing commands.

## Usage

```sh
# Validate a config file
configctl validate config.toml

# Validate against a schema
configctl validate config.yaml --schema schema.json

# Convert between formats
configctl convert config.toml --output-format json
```

## Development

```sh
cargo build            # Build all crates
cargo test             # Run all tests
cargo clippy           # Lint
cargo fmt --check      # Check formatting
```

## License

MIT
