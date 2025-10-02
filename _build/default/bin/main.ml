open Camlfetch

let sysinfo_s =
  let hours, minutes, _seconds = Uptime.get_uptime () in
  Printf.sprintf
    "%s\nMEM\t%d / %d\nCPU\t%f\nPACMAN\t%d\nSHELL\t%s\nUPTIME\t%d:%d\n%s"
    Distro.distro_name
    (Mem.mem_free |> Mem.get_mem_value |> Util.kb_string_to_mb)
    (Mem.mem_total |> Mem.get_mem_value |> Util.kb_string_to_mb)
    Cpu.cpu_usage (Packages.pacman_count ()) (Shell.get_shell ()) hours minutes
    (Palette.palette "R")

let art = Ascii.read_art "/home/gabriel/.local/share/fastfetch/ascii/arch.txt"

let () =
  Ascii.print_concat_art_sysinfo art (String.split_on_char '\n' sysinfo_s)
