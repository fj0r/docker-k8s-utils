use std::process::{Command};
use std::error::Error;

pub fn run_cmd(cmd: &str) -> Result<(), Box<dyn Error>> {
    for c in cmd.split(',') {
        let mut command = Command::new("bash");
        command.arg("-c").arg(c);
        let r = match command.output() {
            Ok(output) => (
                output.status.code().unwrap_or(if output.status.success() { 0 } else { 1 }),
                String::from_utf8_lossy(&output.stdout[..]).into_owned(),
                String::from_utf8_lossy(&output.stderr[..]).into_owned()
            ),
            Err(e) => (126, String::new(), e.to_string()),
        };

        if r.0 > 0 {
            println!("code: {} \n{}", r.0, r.2);
            return Err(r.2.into());
        } else {
            print!("{}", r.1);
        }
    }

    return Ok(());
}

