let hostname () =
  let ic = open_in "/etc/hostname" in
  let name = input_line ic in
  close_in ic ; String.trim name

let username () = Unix.getenv "USER"

let get_user_host () = Printf.sprintf "%s@%s" (username ()) (hostname ())
