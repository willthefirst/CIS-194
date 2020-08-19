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
        

-- parseMessage "E 2 562 help help"== LogMessage (Error 2) 562 "help help"
-- parseMessage "I 29 la la la"== LogMessage Info 29 "la la la"
-- parseMessage "This is not in the right format"== Unknown "This is not in the right format"