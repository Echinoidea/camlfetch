open Sexplib.Std

type t =
  { show_os: bool
  ; show_kernel: bool
  ; show_uptime: bool
  ; show_packages: bool
  ; show_shell: bool
  ; show_resolution: bool
  ; show_de: bool
  ; show_wm: bool
  ; show_terminal: bool
  ; show_cpu: bool
  ; show_gpu: bool
  ; show_memory: bool
  ; show_disk: bool
  ; cpu_usage: bool
  ; memory_percentage: bool
  ; ascii_art: string }
[@@deriving sexp]

(* Default configuration *)
let default =
  { show_os= true
  ; show_kernel= true
  ; show_uptime= true
  ; show_packages= true
  ; show_shell= true
  ; show_resolution= true
  ; show_de= true
  ; show_wm= true
  ; show_terminal= true
  ; show_cpu= true
  ; show_gpu= true
  ; show_memory= true
  ; show_disk= true
  ; cpu_usage= false
  ; memory_percentage= false
  ; ascii_art= "auto" }

(* Load config from file *)
let load_from_file filename =
  try
    let sexp = Sexplib.Sexp.load_sexp filename in
    Ok (t_of_sexp sexp)
  with
  | Sys_error msg ->
      Error (`File_error msg)
  | Sexplib.Conv.Of_sexp_error (exc, _) ->
      Error (`Parse_error (Printexc.to_string exc))
