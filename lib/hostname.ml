let hostname =
  let login =
    CPrintf.csprintf CPrintf.blue "%s" (Unix.getlogin () |> String.trim)
  in
  let hostname =
    CPrintf.csprintf CPrintf.blue "%s" (Unix.gethostname () |> String.trim)
  in
  String.concat "@" [login; hostname]
