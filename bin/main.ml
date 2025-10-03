open Camlfetch

let sysinfo_s =
  let hours, minutes, _seconds = Uptime.get_uptime () in
  Printf.sprintf
    "%s\n\
     MEM\t%d / %d\n\
     CPU\t%d%%\n\
     DISK\t%d/%d GB\n\
     PACMAN\t%d\n\
     SHELL\t%s\n\
     UPTIME\t%d:%d\n\
     OCaml\t%s\n\
     %s\n"
    Distro.distro_name
    (Mem.mem_free |> Mem.get_mem_value |> Util.kb_string_to_mb)
    (Mem.mem_total |> Mem.get_mem_value |> Util.kb_string_to_mb)
    (int_of_float Cpu.cpu_usage)
    Disk.disk_used Disk.disk_total (Packages.pacman_count ())
    (Shell.get_shell ()) hours minutes Ocaml.ocaml_version (Palette.palette "*")

let art = Ascii.read_art "/home/gabriel/.local/share/fastfetch/ascii/frog"

let conf =
  match Config.load_from_file "/home/gabriel/.config/camlfetch.sexp" with
  | Ok cfg ->
      cfg
  | Error _ ->
      Config.default

let () =
  Ascii.print_concat_art_sysinfo art conf.ascii_art_color
    (String.split_on_char '\n' sysinfo_s)
    conf.sysinfo_color
