module OptParse (Option(..), OptType(..), parse) where

import System.Environment

data OptType = Bool | String | Number
data Option = Option { optionNames :: [String], 
                       optionType :: OptType, 
                       optionDoc :: String }

parse :: [Option] -> [String] -> ([(String, String)], [String])
parse options args =
  getOptions options args [] []

getOptions _ [] optAcc argAcc =
  (optAcc, reverse argAcc)
getOptions optList (k:argList) optAcc argAcc =
  case optP optList k of
    Just Bool -> rec argList ((k, "True"):optAcc) argAcc
    Just String -> rec (tail argList) ((k, head argList):optAcc) argAcc
    Nothing -> rec argList optAcc (k:argAcc)
  where rec = getOptions optList

optP :: [Option] -> String -> Maybe OptType
optP [] k = 
  Nothing
optP (opt:rest) k =
  case elem k (optionNames opt) of
    True -> Just . optionType $ opt
    False -> optP rest k