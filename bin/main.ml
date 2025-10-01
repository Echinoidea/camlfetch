open Camlfetch

let sysinfo_s =
  let hours, minutes, _seconds = Uptime.get_uptime () in
  Printf.sprintf
    "%s\n\
     MEM\t\t%d / %d\n\
     CPU\t\t%f\n\
     PACMAN\t\t%d\n\
     SHELL\t\t%s\n\
     UPTIME\t\t%d hours, %d minutes"
    Distro.distro_name
    (Mem.mem_free |> Mem.get_mem_value |> Util.kb_string_to_mb)
    (Mem.mem_total |> Mem.get_mem_value |> Util.kb_string_to_mb)
    Cpu.cpu_usage
    (Packages.get_pacman_count ())
    (Shell.get_shell ()) hours minutes

let art = Ascii.read_art "/home/gabriel/.local/share/fastfetch/ascii/arch.txt"

let () =
  Ascii.print_concat_art_sysinfo art (String.split_on_char '\n' sysinfo_s)
