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

let () =
  Printf.printf "mem_total %d\nmem_free %d\ncpu %f\n"
    (mem_total |> get_mem_value |> kb_string_to_mb)
    (mem_free |> get_mem_value |> kb_string_to_mb)
    cpu_usage
