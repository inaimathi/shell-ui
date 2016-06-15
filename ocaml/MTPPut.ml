let tail = function
  | [] -> [];
  | (a::rest) -> rest
;;

let copy_file fname =
  Printf.printf "Copying \"%s\"...\n" fname ;
  Sys.command (Printf.sprintf "mtp-sendfile \"%s\" \"%s\"" fname fname)
;;

let copy_files fs = List.map copy_file fs ;;

let arg_list = Array.to_list Sys.argv
    in copy_files (tail arg_list)
;;
