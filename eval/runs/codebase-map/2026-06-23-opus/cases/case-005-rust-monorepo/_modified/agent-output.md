# Codebase Map: configctl

## Directory Structure

```
.
├── Cargo.toml              # Workspace root — resolver v2, defines shared deps
├── README.md               # Project overview and usage examples
├── input.yaml              # Metadata file describing repo focus areas
├── output/                 # Empty directory (likely for build/test artifacts)
├── crates/
│   ├── config-core/        # Shared library crate
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs      # Public API: ConfigFormat, parse(), validate(), Schema
│   │       └── error.rs    # Error types: ParseError, ValidationError
│   └── configctl/          # CLI binary crate
│       ├── Cargo.toml
│       └── src/
│           └── main.rs     # CLI entry point with clap-based subcommands
```

## Architecture Overview

**Pattern:** Cargo workspace monorepo with a library + binary split.

- **`config-core`** is the shared library. It provides:
  - `ConfigFormat` enum with `from_extension()` for format detection (TOML, YAML, JSON).
  - `parse()` — parses a config string into a `serde_json::Value`, normalizing all formats to JSON internally. TOML goes through a double-serialize path (TOML -> `toml::Value` -> JSON string -> `serde_json::Value`).
  - `validate()` — validates a parsed value against a `Schema` (currently just checks for required top-level keys).
  - Error types via `thiserror`: `ParseError` (wraps format-specific errors), `ValidationError` (missing key, expected object).

- **`configctl`** is the CLI binary. It uses `clap` derive macros to define two subcommands:
  - `validate <file> [--schema <path>]`
  - `convert <file> --output-format <fmt>`
  - **Both subcommands are currently stubs** — they print placeholders but don't actually read files, parse, or validate.

**Data flow (intended):** File path -> read file -> detect format via extension -> `parse()` -> optionally `validate()` against schema -> serialize to target format (for convert).

## Build and Test Commands

```sh
cargo build            # Build all crates
cargo test             # Run all tests
cargo clippy           # Lint
cargo fmt --check      # Check formatting
```

No custom Makefile, justfile, or CI configuration is present.

## Key Dependencies

| Dependency    | Version | Purpose                                      |
|---------------|---------|----------------------------------------------|
| `serde`       | 1.0     | Serialization framework (with `derive`)      |
| `serde_json`  | 1.0     | JSON parsing/serialization, internal IR      |
| `serde_yaml`  | 0.9     | YAML parsing                                 |
| `toml`        | 0.8     | TOML parsing                                 |
| `thiserror`   | 1.0     | Ergonomic error type derivation              |
| `clap`        | 4.4     | CLI argument parsing (with `derive` feature) |

All workspace dependencies are managed centrally in the root `Cargo.toml`.

## Risk Areas

1. **CLI is entirely stubbed out.** `main.rs` prints placeholder messages but never calls `config_core::parse()` or `validate()`. The library and CLI are disconnected — no integration exists yet.

2. **No tests.** There are zero `#[test]` functions anywhere in the workspace. The library's `parse()` and `validate()` functions have no test coverage.

3. **TOML parse path is lossy.** The TOML parser round-trips through `toml::Value` -> JSON string -> `serde_json::Value`. This double serialization can lose TOML-specific information (e.g., datetime types, integer precision) and is less efficient than a direct conversion.

4. **No serialization/output support.** There is no function to convert a `serde_json::Value` back to TOML or YAML strings — the `convert` command has no implementation path even with the library.

5. **Schema is minimal.** The `Schema` struct only supports required-key validation. There's no way to load a schema from a file (the `--schema` CLI flag has no backing implementation).

6. **No file I/O.** The library operates on `&str` input only. There is no file-reading utility, format-from-path detection, or output-writing capability. The CLI will need to bridge this gap.

## Recommended First Tasks

1. **Add unit tests for `config-core`.** Write tests for `ConfigFormat::from_extension()`, `parse()` with valid/invalid inputs for each format, and `validate()` with present/missing keys. This is the highest-value, lowest-risk starting point.

2. **Wire up the CLI.** Implement the `validate` and `convert` subcommands in `main.rs` to actually read files, detect format from the file extension, call `parse()`, and print results. Add proper error handling with `std::process::exit`.

3. **Add serialization functions to `config-core`.** Implement `serialize(value: &Value, format: ConfigFormat) -> Result<String, _>` to enable the `convert` command. This closes the read-parse-write loop.

4. **Add schema loading.** Implement a function to load a `Schema` from a JSON file (reading the `--schema` path and parsing required keys from it), enabling the validate-against-schema workflow.

5. **Add CI configuration.** Create a GitHub Actions workflow (or similar) that runs `cargo test`, `cargo clippy`, and `cargo fmt --check` on PRs, since no CI exists today.
