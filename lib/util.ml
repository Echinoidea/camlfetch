let head n content = String.split_on_char '\n' content |> fun l -> List.nth l n

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
