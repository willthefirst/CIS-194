{-# LANGUAGE FlexibleInstances, TypeSynonymInstances #-}
module JoinListBuffer where 
import Data.Monoid

import Buffer
import JoinList
import Sized
import Scrabble

instance Buffer (JoinList (Score, Size) String) where
    toString              = unlines . jlToList
    fromString s          =
        foldl (\acc line -> newJL line +++ acc) Out (reverse (lines s)) 
            where newJL str = Single (scoreString str, Size (length $ words str)) str
    line                  = indexJ
    replaceLine n s jl    = replaceLine' (takeJ (n-1) jl) (dropJ n jl)
        where replaceLine' pre Out    = pre
              replaceLine' pre post     = pre +++ (Single (scoreString s, Size (length $ words s)) s) +++ post
    numLines              = length . jlToList
    value                 = sizeOf