{-# OPTIONS_GHC -Wall #-}
module LogAnalysis where
    
import Log

parseMessage :: String -> LogMessage
parseMessage line =
    case words line of
        (['E']:n:t:xs) -> LogMessage (Error (read n)) (read t) (unwords xs)
        (['I']:t:xs) -> LogMessage Info (read t) (unwords xs)
        (['W']:t:xs) -> LogMessage Warning (read t) (unwords xs)
        xs -> Unknown (unwords xs)
        
parse :: String -> [LogMessage]
parse fileAsString =
    map parseMessage (lines fileAsString)