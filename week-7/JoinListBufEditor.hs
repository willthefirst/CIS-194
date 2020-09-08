module Main where

import Editor
import JoinListBuffer

import JoinList
import Sized
import Scrabble


testString = "This Web site includes information about Project Gutenberg-tm, \n including how to make donations to the Project Gutenberg LiQQQQQQQQQQQQQQterarLiQQQQQQQQQQQQQQteraryLiQQQQQQQQQQQQQQteraryLiQQQQQQQQQQQQQQteraryLiQQQQQQQQQQQQQQteraryLiQQQQQQQQQQQQQQteraryLiQQQQQQQQQQQQQQteraryLiQQQQQQQQQQQQQQteraryLiQQQQQQQQQQQQQQteraryLiQQQQQQQQQQQQQQteraryLiQQQQQQQQQQQQQQteraryy \n Archive Foundation, how to help produce our new eBooks, and how to \n subscribe to our email newsletter to hear about new eBooks."

newJL :: String -> JoinList (Score, Size) String
newJL s = Single (scoreString s, Size (length $ words s)) s

testBuffer :: JoinList (Score, Size) String
testBuffer = foldr (\line acc -> acc +++ newJL line) Empty $ (reverse . lines) testString 

-- todo: OK: when Sizes are equal something gets fucked.

testBufferFails = 
    (Append (Score 353,Size 40) 
        (Append (Score 279,Size 30) 
            (Append (Score 182,Size 18) 
                (Append (Score 88,Size 8) 
                    Empty 
                    (Single (Score 88,Size 8) "This Web site includes information about Project Gutenberg-tm, ")
                ) 
                (Single (Score 94,Size 10) " including how to make donations to the Project Gutenberg Literary ")
            ) 
            (Single (Score 97,Size 12) " Archive Foundation, how to help produce our new eBooks, and how to ")
        ) 
        (Single (Score 74,Size 10) " subscribe to our email newsletter to hear about new eBooks.")) 

testBufferFails2 :: JoinList (Score, Size) String
testBufferFails2 = 
    (Append (Score 8, Size 10)
        (Single (Score 4, Size 5) "sone sjs jhhh hs ah")
        (Single (Score 4, Size 5) "2 sjs asssj hs ah"))

-- *0: Bababooie
--  1: aisdhasdhasdhsadsa sjs jhhh hs ah
testBufferWorks :: JoinList (Score, Size) String
testBufferWorks = 
    (Append (Score 8, Size 10)
        (Single (Score 4, Size 3) "sone sjs jhhh hs ah")
        (Single (Score 4, Size 5) "2 sjs asssj hs ah"))


main = runEditor editor $ testBufferWorks
    

-- Prompt before '>' shows (Score, Size) <= Scrabble Score, Number of words in document.
-- Current challenge is to convert our big-ass string from carol.txt into a JoinList structure, caching size and score of each node (where the top node will contain the total.)
-- Right now, it's just loading the entire txt string as a single node.
-- However, when provided with a string, it has no problem converting the file.

-- convert a big string of lines into a big ol JoinList
-- - lines carol.txt (["here is the first line", "now the second", "now the third"])
-- - foldr (\line acc -> acc +++ Single (scoreString line, length words line)) Empty lines

-- Append (Score 353,Size 40) 
--     (Append (Score 279,Size 30) 
--         (Append (Score 182,Size 18) 
--             (Append (Score 88,Size 8) 
--                 Empty 
--                 (Single (Score 88,Size 8) "This Web site includes information about Project Gutenberg-tm, ")
--             ) 
--             (Single (Score 94,Size 10) " including how to make donations to the Project Gutenberg Literary ")
--         ) 
--         (Single (Score 97,Size 12) " Archive Foundation, how to help produce our new eBooks, and how to ")
--     ) 
--     (Single (Score 74,Size 10) " subscribe to our email newsletter to hear about new eBooks."
-- )