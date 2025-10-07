let disk_space path =
  let cmd = Printf.sprintf "df -B1 %s | tail -1" path in
  let ic = Unix.open_process_in cmd in
  let line = input_line ic in
  let _ = Unix.close_process_in ic in
  let content =
    String.split_on_char ' ' line |> List.filter (fun s -> s <> "")
  in
  match content with
  | _ :: total :: used :: available :: _ ->
      let bytes_to_gb s = float_of_string s /. (1024. *. 1024. *. 1024.) in
      ( int_of_float (bytes_to_gb total)
      , int_of_float (bytes_to_gb used)
      , int_of_float (bytes_to_gb available) )
  | _ ->
      failwith "Failed to parse df"

let get_disk_usage = (Unix.stat (Unix.getenv "HOME")).st_size / 10

let disk_total, disk_used, disk_available = disk_space "/home/gabriel/"
