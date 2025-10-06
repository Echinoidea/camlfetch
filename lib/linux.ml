let get_arch () =
  let ic = Unix.open_process_in "uname -m" in
  let arch = input_line ic |> String.trim in
  let _ = Unix.close_process_in ic in
  arch

let get_os () = String.concat " " [Distro.distro_name; get_arch ()]

let get_kernel () =
  let ic = open_in "/proc/sys/kernel/osrelease" in
  let kernel = input_line ic |> String.trim in
  close_in ic ;
  String.concat " " ["Linux"; kernel]
