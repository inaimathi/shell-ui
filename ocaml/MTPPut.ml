(* MTPPut.ml *)

let tail = function
  | [] -> [];
  | (a::rest) -> rest
;;

let copy_file fname =
  Printf.printf "Copying \"%s\"...\n" fname;
  Sys.command (Printf.sprintf "mtp-sendfile \"%s\" \"%s\"" fname fname)
;;

let arg_list = Array.to_list Sys.argv
    in List.map copy_file (tail arg_list)
;;
