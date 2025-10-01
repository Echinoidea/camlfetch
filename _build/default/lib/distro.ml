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

let distro_name =
  read_os_release () |> Util.head 0 |> String.split_on_char '"'
  |> fun l -> List.nth l 1
