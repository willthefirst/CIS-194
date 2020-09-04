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


-- Testing

testCase1 = Empty

testCase2 = (Append (Size 1) Empty (Single (Size 1) "e"))

testCase3 = (Append (Size 1) (Single (Size 1) "e") Empty)

testCase4 = (Single (Size 1) "e")

testCase5 =
    (Append (Size 4)
        (Single (Size 1) "h")
        (Append (Size 3)
            (Single (Size 1) "y")
            (Append (Size 2)
              (Append (Size 1) (Single (Size 1) "e") Empty)
              (Single (Size 1) "a"))))

testCase6 =
    (Append (Size 4)
        (Single (Size 1) "h")
        (Append (Size 3)
            (Append (Size 2)
              (Single (Size 1) "a")
              (Append (Size 1) (Single (Size 1) "e") Empty))
            (Single (Size 1) "y")))

testCase7 =
    (Append (Size 4)
        (Append (Size 3)
            (Single (Size 1) "y")
            (Append (Size 2)
              (Append (Size 1) (Single (Size 1) "e") Empty)
              (Single (Size 1) "a")))
        (Single (Size 1) "h"))

testCases :: [JoinList Size [Char]]
testCases = [testCase1, testCase2, testCase3, testCase4, testCase5, testCase6, testCase7]

(!!?) :: [a] -> Int -> Maybe a
[]     !!? _            = Nothing
_      !!? i | i < 0    = Nothing
(x:xs) !!? 0            = Just x
(x:xs) !!? i            = xs !!? (i-1)

jlToList :: JoinList m a -> [a]
jlToList Empty            = []
jlToList (Single _ a)     = [a]
jlToList (Append _ l1 l2) = jlToList l1 ++ jlToList l2

testIndexJ :: String
testIndexJ
  | all (\(i, jl) -> (indexJ i jl) == (jlToList jl !!? i))
    [(i, jl) | i <- [-1..4], jl <- testCases] = "Pass!"
  | otherwise = "Failed!"

testDropJ :: String
testDropJ
  | all (\(i, jl) -> jlToList (dropJ i jl) == drop i (jlToList jl))
    [(i, jl) | i <- [-1..4], jl <- testCases] = "Pass!"
  | otherwise = "Failed!"

-- 1.

indexJ :: (Sized b, Monoid b) => Int -> JoinList b a -> Maybe a
indexJ _ Empty                  = Nothing
indexJ i _  | i < 0             = Nothing
indexJ i jl | i >= sizeOf jl    = Nothing 
indexJ 0 (Single b a)           = Just a
indexJ i (Append b jl1 jl2)
    | i < sizeOf jl1            = indexJ (i) jl1
    | otherwise                 = indexJ (i - sizeOf jl1) jl2

-- Returns size of a JoinList
sizeOf :: (Sized b, Monoid b) => JoinList b a -> Int
sizeOf Empty  = 0
sizeOf jl     = getSize $ size (tag jl) 

-- 2.

dropJ :: (Sized b, Monoid b) => Int -> JoinList b a -> JoinList b a
dropJ i jl | i < 1      = jl
dropJ _ Empty           = Empty
dropJ i jl 
    | i >= sizeOf jl    = Empty
dropJ i (Append b jl1 jl2)             
    | i <= sizeOf jl1   = (dropJ i jl1) +++ jl2 
    | otherwise         = dropJ (i - sizeOf jl1) jl2

-- 3.

