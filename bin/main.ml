open Camlfetch

let conf =
  match
    Config.load_from_file
      (Unix.getenv "HOME" ^ "/.config/camlfetch/camlfetch.sexp")
  with
  | Ok cfg ->
      cfg
  | Error (`File_error _msg) ->
      Printf.eprintf "Error loading config" ;
      Config.default
  | Error (`Parse_error _msg) ->
      Printf.eprintf "Error loading config" ;
      Config.default

(* Attempt to load cache, if fail, generate info and write to cache *)
let cache = Cache.get_or_create ()

let art =
  Ascii.read_art
    ( match conf.ascii_art with
    | "auto" ->
        Unix.getenv "HOME" ^ "/.config/camlfetch/art/arch"
    | path ->
        path )

let fields =
  List.filter_map
    (fun item ->
      match item with
      (* Static fields loaded from cache *)
      | Config.Hostname ->
          Some (Printf.sprintf "%s" cache.hostname)
      | Config.Os ->
          Some (Printf.sprintf "OS\t%s" cache.os)
      | Config.Cpu ->
          Some (Printf.sprintf "CPU\t%s" cache.cpu)
      | Config.Gpu ->
          Some (Printf.sprintf "GPU\t%s" cache.gpu)
      | Config.Memory ->
          Some
            (Printf.sprintf "MEM\t%d / %d MB"
               (Mem.mem_used |> Util.kb_to_mb)
               (cache.memory_total |> Util.kb_string_to_mb) )
      | Config.Disk ->
          Some (Printf.sprintf "DISK\t%d/%s GB" Disk.disk_used cache.disk_total)
      (* Dynamic fields generated at runtime *)
      | Config.Sep ->
          Some (Printf.sprintf "")
      | Config.Kernel ->
          Some (Printf.sprintf "KERNEL\t%s" (Linux.get_kernel ()))
      | Config.Uptime ->
          let hours, minutes, _seconds = Uptime.get_uptime () in
          Some (Printf.sprintf "UPTIME\t%d:%d" hours minutes)
      | Config.Packages ->
          Some (Printf.sprintf "PACMAN\t%d" (Packages.pacman_count ()))
      | Config.Shell ->
          Some (Printf.sprintf "SHELL\t%s" (Shell.get_shell ()))
      | Config.Ocaml ->
          Some (Printf.sprintf "OCAML\t%s" Ocaml.ocaml_version)
      | Config.Palette ->
          Some (Printf.sprintf "%s" (Palette.palette conf.palette_string))
      | Config.MemPercent ->
          Some (Printf.sprintf "MEM\t%d%%" (int_of_float Mem.mem_percent))
      | Config.Ip ->
          Some (Printf.sprintf "IP\t%s" (Ip.get_host_ip_addr ())) )
    conf.module_order

let () =
  Ascii.print_concat_art_sysinfo art conf.ascii_art_color fields
    conf.sysinfo_color conf.truncate_padding

(* DONE: Cache constant sysinfo data like OS, login, hostname, device model names, and whatever else i can think of in a sexp file. Create the file first run, read sexp file a single time *)
(* on further executions and get all info at once *)
(* TODO: Remove all Unix process calls and only read from files if possible. tput may be the only exception *)
(* DONE: Add truncate terminal padding to config because terminals can have their own padding idk *)
(* TODO: Make different colors for module name and module info *)
(* TODO: Make config parse paths starting with "~/" as Unix.getenv "HOME" *)
(* DONE: Better truncating, paricularly for long lines like device names, *)
(* currently really inconsistent *)
(* TODO: Ascii art justification start center end *)
