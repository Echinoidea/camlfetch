open Camlfetch

let art = Ascii.read_art "/home/gabriel/.local/share/fastfetch/ascii/arch.txt"

let conf =
  match Config.load_from_file "/home/gabriel/.config/camlfetch.sexp" with
  | Ok cfg ->
      cfg
  | Error _ ->
      Config.default

(*I want a function that takes a bool from conf, a field title, a field value, and index *)
(* This will iterate over all potential fields, and only return a string with content if cfg_includes *)
let field cfg_includes formatted_string =
  if cfg_includes then formatted_string else ""

let hours, minutes, _seconds = Uptime.get_uptime ()

let fields =
  [ field conf.show_memory
      (Printf.sprintf "MEM\t%d / %d MB"
         (Mem.mem_free |> Mem.get_mem_value |> Util.kb_string_to_mb)
         (Mem.mem_total |> Mem.get_mem_value |> Util.kb_string_to_mb) )
  ; field conf.show_cpu
      (Printf.sprintf "CPU\t%d%%" (int_of_float Cpu.cpu_usage))
  ; field conf.show_disk
      (Printf.sprintf "DISK\t%d/%d GB" Disk.disk_used Disk.disk_total)
  ; field conf.show_packages
      (Printf.sprintf "PACMAN\t%d" (Packages.pacman_count ()))
  ; field conf.show_shell (Printf.sprintf "SHELL\t%s" (Shell.get_shell ()))
  ; field conf.show_uptime (Printf.sprintf "UPTIME\t%d:%d" hours minutes)
  ; field conf.show_ocaml (Printf.sprintf "OCAML\t%s" Ocaml.ocaml_version)
  ; field conf.show_palette (Printf.sprintf "%s" (Palette.palette "*")) ]

let sysinfo_s = String.concat "\n" fields

let () =
  Ascii.print_concat_art_sysinfo art conf.ascii_art_color
    (String.split_on_char '\n' sysinfo_s)
    conf.sysinfo_color
