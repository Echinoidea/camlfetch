open Sexplib.Std

type module_item =
  | Hostname
  | Os
  | Kernel
  | Uptime
  | Packages
  | Shell
  | Cpu
  | Gpu
  | Ocaml
  | Palette
  | Memory
  | MemPercent
  | Disk
  | Ip
  | Sep
[@@deriving sexp] [@@warning "-37"]

type t =
  { module_order: module_item list
  ; memory_percentage: bool
  ; ascii_art: string
  ; ascii_art_color: string
  ; sysinfo_color: string
  ; palette_string: string
  ; truncate_padding: int }
[@@deriving sexp]

let default =
  { module_order=
      [ Hostname
      ; Sep
      ; Os
      ; Kernel
      ; Uptime
      ; Packages
      ; Shell
      ; Cpu
      ; Gpu
      ; Ocaml
      ; MemPercent
      ; Disk
      ; Ip
      ; Palette ]
  ; memory_percentage= false
  ; ascii_art= "auto"
  ; ascii_art_color= "blue"
  ; sysinfo_color= "white"
  ; palette_string= "*"
  ; truncate_padding= 16 }

(* TODO: Make paths starting with "~/" parse as Unix.getenv "HOME". Make a path type that path elements use, *)
(* have custom parse function for path types *)

let load_from_file filename =
  try
    let sexp = Sexplib.Sexp.load_sexp filename in
    Ok (t_of_sexp sexp)
  with
  | Sys_error msg ->
      Error (`File_error msg)
  | Sexplib.Conv.Of_sexp_error (exc, _) ->
      Error (`Parse_error (Printexc.to_string exc))

let should_display conf item = List.mem item conf.module_order
