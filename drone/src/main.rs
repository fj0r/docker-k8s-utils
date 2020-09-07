

use std::env::{var,VarError};
use std::path::PathBuf;
use std::io::Result as IoResult;

fn get_env(has_kubernetes: bool, name: &str) -> Result<String, VarError> {
    let prefix = "PLUGIN";
    let n = name.to_uppercase();
    let name = if has_kubernetes {
        format!("{}_{}_{}", prefix, "KUBERNETES", n)
    } else {
        format!("{}_{}", prefix, n)
    };
    var(&name)
}

fn modify_config_file(path: impl Into<PathBuf>) -> String {
    format!("{:?}", path.into())
}

fn main() {
    let ns= get_env(false, "namespace").unwrap_or("default".to_owned());
    let port = get_env(true, "port").unwrap_or("6443".to_owned());
    let protocol = get_env(false, "protocol").unwrap_or("https".to_owned());
    let host = get_env(false, "hostname");
    let ip = get_env(true, "server").unwrap();
    let server: String = match host {
        Ok(h) => {
            // write /etc/hosts
            println!("write to file `/etc/hosts`: {} {}", ip, h);
            format!("{}://{}:{}", protocol, h, port)
        },
        Err(_) => {
            format!("{}://{}:{}", protocol, ip, port)
        }
    };

    let home = var("HOME").unwrap();
    let config_path = var("KUBECONFIG").unwrap_or(format!("{}/.kube/config", home));
    println!("{}", modify_config_file(config_path)) ;

    get_env(true, "server").unwrap_or("".to_owned());

    println!("{}\n{}\n{}\n{}\n{}", ns, port, protocol, ip, server);
}
