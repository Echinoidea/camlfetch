let get_uptime () =
  try
    let ic = open_in "/proc/uptime" in
    let uptime_info = input_line ic in
    close_in ic ;
    let uptime_seconds_str = List.hd (String.split_on_char ' ' uptime_info) in
    let uptime_seconds = float_of_string uptime_seconds_str in
    let hours = int_of_float (uptime_seconds /. 3600.0) in
    let minutes = int_of_float (mod_float uptime_seconds 3600.0 /. 60.0) in
    let seconds = int_of_float (mod_float uptime_seconds 60.0) in
    (hours, minutes, seconds)
  with Sys_error _ | End_of_file | Failure _ -> (0, 0, 0)
