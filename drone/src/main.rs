

use std::env::{var};
use std::fs;
mod lib;
use lib::config::KubeConfig;
use lib::opt::Opt;
use lib::run_cmd;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let home = var("HOME")?;
    let config_path = var("KUBECONFIG").unwrap_or(format!("{}/.kube/config", home));
    use structopt::StructOpt;
    let opt = Opt::from_args();
    let mut cfg: KubeConfig  = serde_yaml::from_str(&fs::read_to_string(&config_path)?)?;


    cfg.clusters[0].cluster.server = opt.url(&opt.dry_run)?;
    cfg.clusters[0].cluster.ca = opt.cert;
    cfg.users[0].user.token = opt.token;
    cfg.contexts[0].context.namespace = opt.namespace;


    if opt.dry_run {
        println!("{}", serde_yaml::to_string(&cfg)?);
    } else {
        let _ = fs::write(config_path, serde_yaml::to_string(&cfg)?);
    }

    if let Some(cmd) = opt.cmd {
        run_cmd(&cmd);
    }
    Ok(())
}
