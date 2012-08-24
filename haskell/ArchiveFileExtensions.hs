module ArchiveFileExtensions (archiveTypes, archiveCmds) where

import System.FilePath.Posix

archiveTypes = [(".tar",     ("tar -xvf", "tar -cvf")),
                (".tar.gz",  ("tar -zxvf", "tar -zcvf")),
                (".tgz",     ("tar -zxvf", "tar -zcvf")),
                (".tar.bz2", ("tar -jxvf", "tar -jcvf")),
                (".rar",     ("unrar", "rar c")),
                (".zip",     ("unzip", "zip -r"))]
               
archiveCmds filename = 
  let (shaved, ext1) = splitExtension filename
  in case lookup ext1 archiveTypes of
    Just list -> list
    Nothing -> let (_, ext2) = splitExtension shaved
                   ext = ext2 ++ ext1
               in case lookup ext archiveTypes of
                 Just list -> list
                 Nothing -> error ("No idea how to deal with '" ++ ext ++ "' files.")