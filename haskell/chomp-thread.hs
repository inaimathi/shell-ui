module Main where

import Network.HTTP
import Data.Text (breakOnEnd, pack, unpack)
import Text.Regex.Posix (getAllTextMatches, (=~))
import System.Process (system)
import System.Directory (doesFileExist)

picReg = "//images.4chan.org/[a-z]+/src/([0-9]+).(jpg|png|gif)"

main = do
  res <- simpleHTTP (getRequest "http://boards.4chan.org/gif/res/5493461") >>= getResponseBody
  mapM_ getNewPic $ picURIs res

picURIs :: String -> [String]
picURIs html = everySecond matches
  where matches = getAllTextMatches $ html =~ picReg

getNewPic uri = do
  exists <- doesFileExist fname
  case exists of
    False -> do getPic uri
                return $ Just uri
    True -> return $ Nothing
  where fname = unpack . snd $ breakOnEnd (pack "/") $ pack uri

getPic uri = system $ "wget http:" ++ uri

everySecond :: [a] -> [a]
everySecond (a:b:rest) = a:as where as = everySecond rest
everySecond _ = []