open Camlfetch

let conf =
  match
    Config.load_from_file "/home/gabriel/.config/camlfetch/camlfetch.sexp"
  with
  | Ok cfg ->
      cfg
  | Error (`File_error msg) ->
      Printf.eprintf "Warning: Could not read config file: %s\n%!" msg ;
      Printf.eprintf "Using default configuration\n%!" ;
      Config.default
  | Error (`Parse_error msg) ->
      Printf.eprintf "Warning: Could not parse config file: %s\n%!" msg ;
      Printf.eprintf "Using default configuration\n%!" ;
      Config.default

let art =
  Ascii.read_art
    ( match conf.ascii_art with
    | "auto" ->
        "/home/gabriel/.local/share/fastfetch/ascii/arch.txt"
    | path ->
        path )

(*function that takes a bool from conf, a field title, a field v
all potential fields, and only return a string with content if cfg_includes *)
let field cfg_includes lazy_formatted_string =
  if cfg_includes then lazy_formatted_string () else ""

let hours, minutes, _seconds = Uptime.get_uptime ()

let fields =
  [ field conf.show_memory (fun () ->
        Printf.sprintf "MEM\t%d / %d MB"
          (Mem.mem_free |> Mem.get_mem_value |> Util.kb_string_to_mb)
          (Mem.mem_total |> Mem.get_mem_value |> Util.kb_string_to_mb) )
  ; field conf.show_cpu (fun () ->
        Printf.sprintf "CPU\t%d%%" (int_of_float (Cpu.cpu_usage ())) )
  ; field conf.show_disk (fun () ->
        Printf.sprintf "DISK\t%d/%d GB" Disk.disk_used Disk.disk_total )
  ; field conf.show_packages (fun () ->
        Printf.sprintf "PACMAN\t%d" (Packages.pacman_count ()) )
  ; field conf.show_shell (fun () ->
        Printf.sprintf "SHELL\t%s" (Shell.get_shell ()) )
  ; field conf.show_uptime (fun () ->
        Printf.sprintf "UPTIME\t%d:%d" hours minutes )
  ; field conf.show_ocaml (fun () ->
        Printf.sprintf "OCAML\t%s" Ocaml.ocaml_version )
  ; field conf.show_palette (fun () ->
        Printf.sprintf "%s" (Palette.palette "*") ) ]

let fields = List.filter (fun s -> s <> "") fields

let sysinfo_s = String.concat "\n" fields

let () =
  Ascii.print_concat_art_sysinfo art conf.ascii_art_color
    (String.split_on_char '\n' sysinfo_s)
    conf.sysinfo_color
