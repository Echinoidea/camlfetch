let read_proc filename =
  let ic = open_in filename in
  let rec read_lines acc =
    try
      let line = input_line ic in
      read_lines (line :: acc)
    with End_of_file -> List.rev acc
  in
  let lines = read_lines [] in
  close_in ic ; String.concat "\n" lines

let read_os_release () =
  let ic = open_in "/etc/os-release" in
  let rec read_lines acc =
    try
      let line = input_line ic in
      read_lines (line :: acc)
    with End_of_file -> List.rev acc
  in
  let lines = read_lines [] in
  close_in ic ; String.concat "\n" lines

let head n content = String.split_on_char '\n' content |> fun l -> List.nth l n

let get_mem_value line =
  String.split_on_char ' ' line |> List.rev |> fun l -> List.nth l 1

let mem_total = read_proc "/proc/meminfo" |> head 0

let mem_free = read_proc "/proc/meminfo" |> head 1

let kb_string_to_mb v =
  let kb = int_of_string v in
  kb / 1000

let _cpu_line = read_proc "/proc/stat" |> head 0

let read_cpu_vals () =
  let cpu_line = read_proc "/proc/stat" |> head 0 in
  let vals = String.split_on_char ' ' cpu_line |> List.tl |> List.tl in
  List.map int_of_string vals

let calculate_cpu_usage times1 times2 =
  let total1 = List.fold_left ( + ) 0 times1 in
  let total2 = List.fold_left ( + ) 0 times2 in
  let idle1 = List.nth times1 3 + List.nth times1 4 in
  let idle2 = List.nth times2 3 + List.nth times2 4 in
  let total_delta = total2 - total1 in
  let idle_delta = idle2 - idle1 in
  100.0 *. (float_of_int (total_delta - idle_delta) /. float_of_int total_delta)

let cpu_usage =
  let times1 = read_cpu_vals () in
  Unix.sleepf 0.5 ;
  let times2 = read_cpu_vals () in
  calculate_cpu_usage times1 times2

let distro_name =
  read_os_release () |> head 0 |> String.split_on_char '"'
  |> fun l -> List.nth l 1

let get_pacman_count () =
  let ic = Unix.open_process_in "pacman -Q" in
  let rec count_lines acc =
    try
      let _ = input_line ic in
      count_lines (acc + 1)
    with End_of_file -> acc
  in
  let count = count_lines 0 in
  let _ = Unix.close_process_in ic in
  count

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

let get_uptime () =
  try
    let ic = open_in "/proc/uptime" in
    let uptime_info = input_line ic in
    close_in ic ;
    (* Split the line to get the first field, which is the uptime in seconds *)
    let uptime_seconds_str = List.hd (String.split_on_char ' ' uptime_info) in
    let uptime_seconds = float_of_string uptime_seconds_str in
    (* Convert the uptime from seconds to hours, minutes, and seconds *)
    let hours = int_of_float (uptime_seconds /. 3600.0) in
    let minutes = int_of_float (mod_float uptime_seconds 3600.0 /. 60.0) in
    let seconds = int_of_float (mod_float uptime_seconds 60.0) in
    (hours, minutes, seconds)
  with Sys_error _ | End_of_file | Failure _ -> (0, 0, 0)

let () =
  let hours, minutes, _seconds = get_uptime () in
  Printf.printf
    "    \t%s\n\
     MEM\t%d / %d\n\
     CPU\t%f\n\
     PACMAN\t%d\n\
     SHELL\t%s\n\
     UPTIME\t%d hours, %d minutes"
    distro_name
    (mem_free |> get_mem_value |> kb_string_to_mb)
    (mem_total |> get_mem_value |> kb_string_to_mb)
    cpu_usage (get_pacman_count ()) (get_shell ()) hours minutes
