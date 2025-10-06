let get_mem_value line =
  String.split_on_char ' ' line |> List.rev |> fun l -> List.nth l 1

let mem_total = Proc.read_proc "/proc/meminfo" |> Util.head 0

let mem_available = Proc.read_proc "/proc/meminfo" |> Util.head 2

let mem_used =
  let total = float_of_int (int_of_string (get_mem_value mem_total)) in
  let available = float_of_int (int_of_string (get_mem_value mem_available)) in
  total -. available

let mem_percent =
  let total = float_of_int (int_of_string (get_mem_value mem_total)) in
  let available = float_of_int (int_of_string (get_mem_value mem_available)) in
  (total -. available) /. total *. 100.0
