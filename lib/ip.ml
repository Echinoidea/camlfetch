let get_ip_addresses () =
  let hostname = Unix.gethostname () in
  let host_entry = Unix.gethostbyname hostname in
  Array.to_list host_entry.Unix.h_addr_list |> List.map Unix.string_of_inet_addr

let get_host_ip_addr () = get_ip_addresses () |> fun l -> List.nth l 1
