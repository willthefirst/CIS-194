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
        foldr (\line acc -> acc +++ newJL line) Empty $ (reverse . lines) s 
            where newJL str = Single (scoreString str, Size 1) str
    line                  = indexJ
    replaceLine n s jl    = replaceLine' (takeJ n jl) (dropJ n jl)
        where replaceLine' pre Empty    = pre
              replaceLine' pre post     = pre +++ (Single (scoreString s, 1) s) +++ post
    numLines              = length . jlToList
    value                 = sizeOf

