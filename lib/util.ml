let head n content = String.split_on_char '\n' content |> fun l -> List.nth l n

let line_at n content =
  String.split_on_char '\n' content
  |> List.filteri (fun i _ -> i = n)
  |> List.hd

let kb_string_to_mb v =
  let kb = int_of_string v in
  kb / 1024

let kb_to_mb v = int_of_float v / 1024

let get_color name =
  match List.assoc_opt name CPrintf.colors with
  | Some color ->
      color
  | None ->
      CPrintf.white

let get_terminal_width () =
  try int_of_string (Unix.getenv "COLUMNS") with _ -> 80

let strip_color str =
  let escape_regex = Str.regexp "\027\\[[0-9;]*m" in
  Str.global_replace escape_regex "" str

let utf8_length str =
  let len = String.length str in
  let rec count pos chars =
    if pos >= len then chars
    else
      let c = Char.code str.[pos] in
      let next_pos =
        if c < 0x80 then pos + 1 (* ASCII *)
        else if c < 0xE0 then pos + 2 (* 2-byte *)
        else if c < 0xF0 then pos + 3 (* 3-byte *)
        else pos + 4 (* 4-byte *)
      in
      count next_pos (chars + 1)
  in
  count 0 0

let rec longest_line_length lines longest =
  match lines with
  | [] ->
      longest
  | line :: rest ->
      let length = line |> strip_color |> utf8_length in
      let new_longest = if length > longest then length else longest in
      longest_line_length rest new_longest

let truncate_string max_width str =
  if max_width > String.length (strip_color str) then str
  else if max_width < 1 then "X"
  else String.sub str 0 max_width
