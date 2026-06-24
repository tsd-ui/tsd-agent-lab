pub mod error;

use serde_json::Value;
pub use error::{ParseError, ValidationError};

/// Supported configuration file formats.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ConfigFormat {
    Toml,
    Yaml,
    Json,
}

impl ConfigFormat {
    /// Detect format from a file extension.
    pub fn from_extension(ext: &str) -> Option<Self> {
        match ext {
            "toml" => Some(Self::Toml),
            "yaml" | "yml" => Some(Self::Yaml),
            "json" => Some(Self::Json),
            _ => None,
        }
    }
}

/// Parse a configuration string into a JSON Value.
pub fn parse(input: &str, format: ConfigFormat) -> Result<Value, ParseError> {
    match format {
        ConfigFormat::Toml => {
            let table: toml::Value = toml::from_str(input)?;
            let json_str = serde_json::to_string(&table)?;
            Ok(serde_json::from_str(&json_str)?)
        }
        ConfigFormat::Yaml => Ok(serde_yaml::from_str(input)?),
        ConfigFormat::Json => Ok(serde_json::from_str(input)?),
    }
}

/// A minimal schema representation for validation.
#[derive(Debug, Clone)]
pub struct Schema {
    pub required_keys: Vec<String>,
}

/// Validate a parsed config value against a schema.
pub fn validate(value: &Value, schema: &Schema) -> Vec<ValidationError> {
    let mut errors = Vec::new();
    if let Some(obj) = value.as_object() {
        for key in &schema.required_keys {
            if !obj.contains_key(key) {
                errors.push(ValidationError::MissingKey(key.clone()));
            }
        }
    } else {
        errors.push(ValidationError::ExpectedObject);
    }
    errors
}
