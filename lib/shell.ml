(* Used gpt for this one *)
let get_shell () =
  try
    (* Get the parent process ID of this program *)
    let ppid = Unix.getppid () in
    (* Read the /proc/[ppid]/comm file to get the name of the parent process *)
    let comm_path = Printf.sprintf "/proc/%d/comm" ppid in
    let ic = open_in comm_path in
    let shell_name = input_line ic in
    close_in ic ; shell_name
  with Sys_error _ | End_of_file -> "Unknown"
