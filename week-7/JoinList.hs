module JoinList where

import Sized

data JoinList m a = Empty
                | Single m a
                | Append m (JoinList m a) (JoinList m a)
    deriving (Eq, Show)

-- Exercise 1

(+++) :: Monoid m => JoinList m a -> JoinList m a -> JoinList m a
(+++) jl1 jl2 = Append (tag jl1 <> tag jl2) jl1  jl2

tag :: Monoid m => JoinList m a -> m
tag Empty = mempty
tag (Single m _) = m
tag (Append m _ _) = m

-- Exercise 2

indexJ :: (Sized b, Monoid b) => Int -> JoinList b a -> Maybe a
indexJ _ Empty                          = Nothing
indexJ i _ | i < 0                      = Nothing
indexJ i jl
    | i >= (getSize $ size (tag jl))    = Nothing 
indexJ 0 (Single b a)                   = Just a
indexJ i (Append b jl1 jl2)
    | i < (getSize $ size (tag jl1))    = indexJ (i) jl1
    | otherwise                         = indexJ (i - (getSize $ size (tag jl1))) jl2

-- Utilities for testing
jlToList :: JoinList m a -> [a]
jlToList Empty            = []
jlToList (Single _ a)     = [a]
jlToList (Append _ l1 l2) = jlToList l1 ++ jlToList l2

(!!?) :: [a] -> Int -> Maybe a
[]     !!? _            = Nothing
_      !!? i | i < 0    = Nothing
(x:xs) !!? 0            = Just x
(x:xs) !!? i            = xs !!? (i-1)

testJL =    
    (Append (Size 4)
        (Append (Size 3)
            (Single (Size 1) "y")
            (Append (Size 2)
                (Single (Size 1) "e")
                (Single (Size 1) "a")))
        (Single (Size 1) "h"))