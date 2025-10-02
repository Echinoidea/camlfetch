let colors =
  [ ("red", CPrintf.red)
  ; ("green", CPrintf.green)
  ; ("yellow", CPrintf.yellow)
  ; ("blue", CPrintf.blue)
  ; ("magenta", CPrintf.magenta)
  ; ("cyan", CPrintf.cyan)
  ; ("white", CPrintf.white) ]

let palette character =
  List.map (fun (_, color) -> CPrintf.csprintf color character) colors
  |> String.concat " "
