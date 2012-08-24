import System.Cmd
import System.Environment
import System.Console.GetOpt
               
import ArchiveFileExtensions

main = do
  args <- getArgs
  mapM unpack args
  
unpack filename =
  system (cmd ++ (q filename))
  where cmd = fst (archiveCmds filename)
        
pack filename = 
  system (cmd ++ (q filename))
  where cmd = snd (archiveCmds filename)
        
q filename = " \"" ++ filename ++ "\""