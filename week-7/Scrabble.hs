{-# LANGUAGE GeneralizedNewtypeDeriving, FlexibleInstances #-}

module Scrabble where

import Data.Map as M
import Data.Char as C

newtype Score = Score Int
    deriving (Eq, Ord, Show, Num)

instance Monoid Score where
    mempty = Score 0

instance Semigroup Score where
  (<>) = (+)

scoreFromInt :: Maybe Int -> Score
scoreFromInt Nothing    = Score 0
scoreFromInt (Just i)   = Score i

score :: Char -> Score
score c = 
    scoreFromInt
    $ M.lookup char letterValues
    where 
        char = C.toLower c
        letterValues = 
            M.fromList [
                ('a', 1),
                ('b', 3),
                ('c', 3), 
                ('d', 2),
                ('e', 1),
                ('f', 4),
                ('g', 2),
                ('h', 4),
                ('i', 1),
                ('j', 8),
                ('k', 5),
                ('l', 1),
                ('m', 3),
                ('n', 1),
                ('o', 1),
                ('p', 3),
                ('q', 10),
                ('r', 1),
                ('s', 1),
                ('t', 1),
                ('u', 1),
                ('v', 4),
                ('w', 4),
                ('x', 8),
                ('y', 4),
                ('z', 10)
            ]

scoreString :: String -> Score
scoreString s =
    Prelude.foldr (+) (Score 0) $ Prelude.map score s
