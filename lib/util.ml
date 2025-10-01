let head n content = String.split_on_char '\n' content |> fun l -> List.nth l n

let kb_string_to_mb v =
  let kb = int_of_string v in
  kb / 1000
