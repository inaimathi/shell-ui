import System.Cmd
import System.IO
import System.Environment
import System.FilePath.Posix

main = do
  args <- getArgs
  mapM convert args
  
convert file = do
  (tmpName, _) <- openTempFile "/tmp/" "tmp.wav"
  toWav tmpName file
  toOgg tmpName name
  rmWav name
    where name = dropExtension file

toWav tmpName orig = 
  system $ concat ["mplayer -novideo -ao pcm:file='", tmpName, "' ", orig]
  
toOgg tmpName new = 
  system $ concat ["pacpl -v -t ogg --outdir ./ --outfile ", new, " ", tmpName]
  
rmWav name = system $ concat ["rm ", name, "*wav"]