type t =
  { hostname: string
  ; os: string
  ; cpu: string
  ; gpu: string
  ; memory_total: string
  ; disk_total: string }

val read_cache : unit -> t option

val write_cache : t -> unit

val get_or_create : unit -> t
