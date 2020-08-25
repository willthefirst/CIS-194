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

insert :: LogMessage -> MessageTree -> MessageTree
insert (Unknown _) mt = mt
insert lm Leaf = Node Leaf lm Leaf
insert lm@(LogMessage _ ts _) mt@(Node left lm'@(LogMessage _ ts' _) right) =
    case ts < ts' of
        True -> insert lm left
        False -> insert lm right

build :: [LogMessage] -> MessageTree
build [] = Leaf
build [x] = Node Leaf x Leaf
build (x:xs) = insert x (build xs)

inOrder :: MessageTree -> [LogMessage]
inOrder Leaf = []
inOrder mt@(Node left lm right) = (inOrder left) ++ [lm] ++ (inOrder right)

whatWentWrong :: [LogMessage] -> [String]
-- whatWentWrong (x:xs) = [(show xs)]
whatWentWrong [] = []
whatWentWrong (lm@(LogMessage (Error sev) _ _):xs) =
    if (sev > 50) then 
        [(show lm)] ++ (whatWentWrong (inOrder (build xs)))
    else
        whatWentWrong (inOrder (build xs))
whatWentWrong (x:xs) =
    whatWentWrong (inOrder (build xs))

-- testWhatWentWrong parse whatWentWrong "sample.log"