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
