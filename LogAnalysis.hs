{-# OPTIONS_GHC -Wall #-}
module LogAnalysis where
    
import Log

parseMessage :: String -> LogMessage
parseMessage line =
    case words line of
        "E", Int, Int, String -> LogMessage (Error 2) 562 "help help"
        "I" ->
        

parseMessage "E 2 562 help help"== LogMessage (Error 2) 562 "help help"