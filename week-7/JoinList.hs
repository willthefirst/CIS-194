{-# LANGUAGE FlexibleInstances, TypeSynonymInstances #-}

module JoinList where

import Sized
import Scrabble
import Buffer

data JoinList m a = Out
                | Single m a
                | Append m (JoinList m a) (JoinList m a)
    deriving (Eq, Show)

-- Exercise 1

(+++) :: Monoid m => JoinList m a -> JoinList m a -> JoinList m a
(+++) jl1 jl2 = Append (tag jl1 <> tag jl2) jl1  jl2

tag :: Monoid m => JoinList m a -> m
tag Out = mempty
tag (Single m _) = m
tag (Append m _ _) = m

-- Exercise 2

-- Testing

testCase1 = Out -- Causes issues, couldn't figure out how to fix.

testCase2 = (Append (Size 1) Out (Single (Size 1) "e"))

testCase3 = (Append (Size 1) (Single (Size 1) "e") Out)

testCase4 = (Single (Size 1) "e")

testCase5 =
    (Append (Size 4)
        (Single (Size 1) "h")
        (Append (Size 3)
            (Single (Size 1) "y")
            (Append (Size 2)
              (Append (Size 1) (Single (Size 1) "e") Out)
              (Single (Size 1) "a"))))

testCase6 =
    (Append (Size 4)
        (Single (Size 1) "h")
        (Append (Size 3)
            (Append (Size 2)
              (Single (Size 1) "a")
              (Append (Size 1) (Single (Size 1) "e") Out))
            (Single (Size 1) "y")))
    
testCase7 =
    (Append (Size 4)
        (Append (Size 3)
            (Single (Size 1) "y")
            (Append (Size 2)
              (Append (Size 1) (Single (Size 1) "e") Out)
              (Single (Size 1) "a")))
        (Single (Size 1) "h"))

testCases :: [JoinList Size [Char]]
testCases = [testCase2, testCase3, testCase4, testCase5, testCase6, testCase7]

(!!?) :: [a] -> Int -> Maybe a
[]     !!? _            = Nothing
_      !!? i | i < 0    = Nothing
(x:xs) !!? 0            = Just x
(x:xs) !!? i            = xs !!? (i-1)

jlToList :: JoinList m a -> [a]
jlToList Out            = []
jlToList (Single _ a)     = [a]
jlToList (Append _ l1 l2) = jlToList l1 ++ jlToList l2

testIndexJ :: (Int -> JoinList Size [Char] -> Maybe [Char]) -> IO ()
testIndexJ indexJ
  | all (\(i, jl) -> (indexJ i jl) == (jlToList jl !!? i))
    [(i, jl) | i <- [-1..4], jl <- testCases] = putStr "Pass!\n"
  | otherwise = putStr $ "Failed!\nTest case: indexJ "++ show i ++ " (" ++ show jl
              ++ ")\nExpecting: " ++ show expecting
              ++ "\nGetting: " ++ show getting ++ "\n"
    where failedCase = head $ filter (\(i, jl) -> (indexJ i jl) /= (jlToList jl !!? i))
                        [(i, jl) | i <- [-1..4], jl <- testCases]
          expecting = (\(i, jl) -> (jlToList jl !!? i)) failedCase
          getting = (\(i, jl) -> (indexJ i jl)) failedCase
          i = fst failedCase
          jl = snd failedCase

testDropJ :: String
testDropJ
  | all (\(i, jl) -> jlToList (dropJ i jl) == drop i (jlToList jl))
    [(i, jl) | i <- [-1..4], jl <- testCases] = "Pass!"
  | otherwise = "Failed!"

testTakeJ :: String
testTakeJ
  | all (\(i, jl) -> jlToList (takeJ i jl) == take i (jlToList jl))
    [(i, jl) | i <- [-1..4], jl <- testCases] = "Pass!"
  | otherwise = "Failed!"

-- 1.

indexJ :: (Sized b, Monoid b) => Int -> JoinList b a -> Maybe a
indexJ _ Out                  = Nothing
indexJ i _  | i < 0             = Nothing
indexJ 0 (Single _ a)           = Just a
indexJ i (Single _ _)           = Nothing
indexJ i (Append b jl1 jl2)
  | i == 0                      = indexJ i jl1
  | otherwise                   = indexJ (i - 1) jl2

-- Returns size of a JoinList
sizeOf :: (Sized b, Monoid b) => JoinList b a -> Int
sizeOf Out  = 0
sizeOf jl     = getSize $ size (tag jl) 
 
-- 2.

dropJ :: (Sized b, Monoid b) => Int -> JoinList b a -> JoinList b a
dropJ i jl | i < 1      = jl
dropJ _ Out           = Out
dropJ i (Single _ _)    = Out
dropJ i (Append b jl1 jl2) = dropJ (i-1) jl2 

-- 3.

takeJ :: (Sized b, Monoid b) => Int -> JoinList b a -> JoinList b a
takeJ _ Out               = Out 
takeJ i _ | i < 1           = Out
takeJ _ (Single b a)        = Single b a
takeJ i (Append b jl1 jl2)  = takeJ i jl1 +++ takeJ (i-1) jl2 


-- testBuffer = 
--   (Append (Score 346,Size 40) 
--       (Single (Score 88,Size 8) "This Web site includes information about Project Gutenberg-tm, ") 
--       (Append (Score 258,Size 32) 
--           (Single (Score 87,Size 10) " including how to make donations to the Project Gutenberg y ") 
--               (Append (Score 171,Size 22) 
--                   (Single (Score 97,Size 12) " Archive Foundation, how to help produce our new eBooks, and how to ") 
--                   (Append (Score 74,Size 10) 
--                       (Single (Score 74,Size 10) " subscribe to our email newsletter to hear about new eBooks.") 
--                       Out
--                   )
--               )
--           ))

    -- replaceLine n s jl    = replaceLine' (takeJ n jl) (dropJ n jl)
    --     where replaceLine' pre Out    = pre
    --           replaceLine' pre post     = pre +++ (Single (scoreString s, Size (length $ words s)) s) +++ post


-- Exercise 3 (see Scrabble.hs for rest of code)

scoreLine :: String -> JoinList Score String
scoreLine s = Single (scoreString s) s

-- Exercise 4 (see JoinListBuffer.hs)
