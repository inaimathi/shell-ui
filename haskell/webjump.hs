import System.Environment
import System.Cmd
import Data.List
import Network.HTTP.Base
import Control.Monad
import Text.Regex.Posix

main = do
  putStrLn "Webjump: " -- putStr doesn't work here, for some reason, though types are identical
  input <- getLine
  system (callJump input)

callJump inStr = 
  let w = words inStr
      q = intercalate " " $ tail w
  in jump (head w) q

jump name query =
  case lookup name templatesfind (isJump name) templates of
    Just (name, jumpFn) -> jumpFn query
    Nothing -> jump "google" query

isJump name tuple = (fst tuple) =~ name

query prefix suffix q = "lynx \"" ++ prefix ++ (urlEncode q) ++ suffix ++ "\""

templates =
  [("youtube", query "http://www.youtube.com/results?search_query=" "&aq=f"),
   ("stockxchange", query "http://www.sxc.hu/browse.phtml?f=search&txt=" "&w=1&x=0&y=0"),
   ("google", query "http://www.google.com/search?q=" "&ie=utf-8&oe=utf-8&aq=t"),
   ("wikipedia", query "http://en.wikipedia.org/wiki/Special:Search?search=" "&sourceid=Mozilla-search"),
   ("gmail", query "http://mail.google.com" "")]