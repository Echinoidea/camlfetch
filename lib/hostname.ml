let hostname =
  let login = CPrintf.csprintf CPrintf.blue "%s" (Unix.getlogin ()) in
  let hostname = CPrintf.csprintf CPrintf.blue "%s" (Unix.gethostname ()) in
  String.concat "@" [login; hostname]
