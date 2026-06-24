use thiserror::Error;

/// Errors that can occur when parsing configuration input.
#[derive(Debug, Error)]
pub enum ParseError {
    #[error("invalid TOML: {0}")]
    Toml(#[from] toml::de::Error),

    #[error("invalid YAML: {0}")]
    Yaml(#[from] serde_yaml::Error),

    #[error("invalid JSON: {0}")]
    Json(#[from] serde_json::Error),
}

/// Errors found during schema validation.
#[derive(Debug, Error, PartialEq, Eq)]
pub enum ValidationError {
    #[error("missing required key: {0}")]
    MissingKey(String),

    #[error("expected top-level object")]
    ExpectedObject,
}
