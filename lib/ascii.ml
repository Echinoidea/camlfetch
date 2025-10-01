let read_art file =
  let content = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' content
  |> List.filter (fun line -> String.trim line <> "")

let _print_art lines = List.iter (fun line -> Printf.printf "%s\n" line) lines

(* Find the shortest length and pad it with \n to match the length of the longer *)
let pad_lines l1 l2 =
  let diff = abs (List.length l1 - List.length l2) in
  match List.length l1 - List.length l2 with
  | 0 ->
      (l1, l2)
  | n when n > 0 ->
      (l1, l2 @ List.init diff (fun _ -> ""))
  | _ ->
      (l1 @ List.init diff (fun _ -> ""), l2)

let print_concat_art_sysinfo art_lines sysinfo_lines =
  let l1, l2 = pad_lines art_lines sysinfo_lines in
  List.iter2 (fun s1 s2 -> Printf.printf "%-30s%s\n" s1 s2) l1 l2
