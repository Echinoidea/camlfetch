let _cpu_line = Proc.read_proc "/proc/stat" |> Util.head 0

let read_cpu_vals () =
  let cpu_line = Proc.read_proc "/proc/stat" |> Util.head 0 in
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
