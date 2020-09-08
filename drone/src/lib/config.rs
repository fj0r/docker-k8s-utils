use serde::{Serialize, Deserialize};

fn ci() -> String { "ci".to_owned() }
fn target() -> String { "target".to_owned() }
fn deployment() -> String { "deployment".to_owned() }
fn v1() -> String { "v1".to_owned() }
fn config() -> String { "Config".to_owned() }

#[derive(Serialize, Deserialize, Debug)]
pub struct Auth {
    pub token: String
}

#[derive(Serialize, Deserialize, Debug)]
pub struct User {
    #[serde(default = "ci")]
    pub name: String,
    pub user: Auth
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Cert {
    #[serde(rename="certificate-authority-data")]
    pub ca: String,
    pub server: String
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Cluster {
    pub cluster: Cert,
    #[serde(default = "target")]
    pub name: String
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Ctx {
    #[serde(default = "target")]
    pub cluster: String,
    pub namespace: String,
    #[serde(default = "ci")]
    pub user: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Context {
    pub context: Ctx,
    #[serde(default = "deployment")]
    pub name: String
}

#[derive(Serialize, Deserialize, Debug)]
pub struct KubeConfig {
    #[serde(default = "v1", rename="apiVersion")]
    pub api_version: String,

    #[serde(default = "config")]
    pub kind: String,

    pub users: Vec<User>,

    pub clusters: Vec<Cluster>,

    pub contexts: Vec<Context>,

    #[serde(rename="current-context", default="deployment")]
    pub current: String,
}