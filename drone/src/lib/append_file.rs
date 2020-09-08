
use std::path::PathBuf;
use std::fs::OpenOptions;
use std::io::prelude::*;
use std::io::Result as IoResult;

pub fn append_hosts(path: impl Into<PathBuf>, addr: &str, host: &str) -> IoResult<()> {
    let p = path.into();
    let mut f = OpenOptions::new().append(true).open(&p)?;
    println!("<-------- write file {:?} -> {} {}", p, addr, host);
    writeln!(f, "{} {}", addr, host)?;
    Ok(())
}