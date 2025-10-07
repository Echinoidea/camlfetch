let pacman_count () =
  let entries = Sys.readdir "/var/lib/pacman/local" in
  Array.length entries - 1
