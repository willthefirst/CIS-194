module Main where

import Editor
import JoinListBuffer

import JoinList
import Sized
import Scrabble


testString = "This Web site includes information about Project Gutenberg-tm, \n including how to make donations to the Project Gutenberg y \n Archive Foundation, how to help produce our new eBooks, and how to \n subscribe to our email newsletter to hear about new eBooks."

newJL :: String -> JoinList (Score, Size) String
newJL s = Single (scoreString s, Size (length $ words s)) s

testBuffer :: JoinList (Score, Size) String
testBuffer =  foldl (\acc line -> newJL line +++ acc) Empty (reverse (lines testString)) 

-- Append (Score 346,Size 40) 
--     (Single (Score 88,Size 8) "This Web site includes information about Project Gutenberg-tm, ") 
--     (Append (Score 258,Size 32) 
--         (Single (Score 87,Size 10) " including how to make donations to the Project Gutenberg y ") 
--             (Append (Score 171,Size 22) 
--                 (Single (Score 97,Size 12) " Archive Foundation, how to help produce our new eBooks, and how to ") 
--                 (Append (Score 74,Size 10) 
--                     (Single (Score 74,Size 10) " subscribe to our email newsletter to hear about new eBooks.") 
--                     Empty
--                 )
--             )
--         )


main = runEditor editor $ testBuffer