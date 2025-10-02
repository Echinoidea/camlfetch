let black = "\027[30m"

let red = "\027[31m"

let green = "\027[32m"

let yellow = "\027[33m"

let blue = "\027[34m"

let magenta = "\027[35m"

let cyan = "\027[36m"

let white = "\027[37m"

let bright_black = "\027[90m"

let bright_red = "\027[91m"

let bright_green = "\027[92m"

let bright_yellow = "\027[93m"

let bright_blue = "\027[94m"

let bright_magenta = "\027[95m"

let bright_cyan = "\027[96m"

let bright_white = "\027[97m"

let reset = "\027[0m"

let cprintf color fmt =
  Printf.ksprintf (fun s -> Printf.printf "%s%s%s" color s reset) fmt

let csprintf color fmt =
  Printf.ksprintf (fun s -> Printf.sprintf "%s%s%s" color s reset) fmt
