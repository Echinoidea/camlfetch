open Sexplib.Std

type t =
  { hostname: string
  ; os: string
  ; cpu: string
  ; gpu: string
  ; memory_total: string
  ; disk_total: string }
[@@deriving sexp]

let cache_path = Unix.getenv "HOME" ^ "/.cache/camlfetch/static_info.sexp"

let ensure_cache_dir () =
  let cache_dir = Filename.dirname cache_path in
  try Unix.mkdir cache_dir 0o755
  with Unix.Unix_error (Unix.EEXIST, _, _) -> ()

let write_cache info =
  ensure_cache_dir () ;
  let sexp = sexp_of_t info in
  let oc = open_out cache_path in
  output_string oc (Sexplib.Sexp.to_string_hum sexp) ;
  close_out oc

let read_cache () =
  try
    let sexp = Sexplib.Sexp.load_sexp cache_path in
    Some (t_of_sexp sexp)
  with _ -> None

let build_cache () =
  { hostname= Hostname.get_user_host ()
  ; os= Linux.get_os ()
  ; cpu= Cpu.cpu_model_name ()
  ; gpu= Gpu.gpu_device_name ()
  ; memory_total= Mem.mem_total |> Mem.get_mem_value
  ; disk_total= string_of_int Disk.disk_total }

(* Attempt to read, if fail, create it *)
let get_or_create () =
  match read_cache () with
  | Some c ->
      c
  | None ->
      let c = build_cache () in
      write_cache c ; c
