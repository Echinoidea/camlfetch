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

let print_concat_art_sysinfo art_lines art_color_name sysinfo_lines
    sysinfo_color_name =
  let art_color = Util.get_color art_color_name in
  let sysinfo_color = Util.get_color sysinfo_color_name in
  let l1, l2 = pad_lines art_lines sysinfo_lines in
  List.iter2
    (fun s1 s2 ->
      let colored_s1 = CPrintf.csprintf art_color "%s" s1 in
      let colored_s2 = CPrintf.csprintf sysinfo_color "%s" s2 in
      Printf.printf "%-30s  %s\n" colored_s1 colored_s2 )
    l1 l2
