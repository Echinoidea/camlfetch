let gpu_device_name () =
  let ic = Unix.open_process_in "glxinfo | grep 'Device:'" in
  let device_name =
    input_line ic |> String.trim |> String.split_on_char ':'
    |> fun l -> List.nth l 1
  in
  device_name
