use std::process::{Command};

pub fn run_cmd(cmd: &str) {
    cmd.split(',').for_each(|cmd| {
        let mut command = Command::new("bash");
        command.arg("-c").arg(cmd);
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
        } else {
            print!("{}", r.1);
        }
    });

}

