let get_mem_value line =
  String.split_on_char ' ' line |> List.rev |> fun l -> List.nth l 1

let mem_total = Proc.read_proc "/proc/meminfo" |> Util.head 0

let mem_free = Proc.read_proc "/proc/meminfo" |> Util.head 1
