{-# LANGUAGE FlexibleInstances #-}
{-# OPTIONS_GHC -fno-warn-missing-methods #-}

-- Exercise 1

fib :: Integer -> Integer
fib n
    | n >= 2 = fib (n-1) + fib (n-2)
    | otherwise = n

fibs1 :: [Integer]
fibs1 = [ fib n | n <- [0..] ]

-- Exercise 2

fibs2 :: [Integer]
fibs2 = map fst (iterate (\(a,b) -> (b, a + b)) (0, 1))

-- Exercise 3

data Stream a = Cons a (Stream a)

instance Show a => Show (Stream a) where
  show x = show $ take 20 (streamToList x)

streamToList :: Stream a -> [a]
streamToList (Cons x xs) = x : streamToList(xs)

-- Exercise 4

streamRepeat :: a -> Stream a
streamRepeat x = Cons x $ streamRepeat x

streamMap :: (a -> b) -> Stream a -> Stream b
streamMap f (Cons x s) = Cons (f x) $ streamMap f s

streamFromSeed :: (a -> a) -> a -> Stream a
streamFromSeed f x = Cons x $ streamFromSeed f (f x)

-- Exercise 5

nats :: Stream Integer
nats = streamFromSeed (+1) 0

interleaveStreams :: Stream a -> Stream a -> Stream a
interleaveStreams (Cons x xs) ys = Cons x $ interleaveStreams ys xs

getExponent :: Integer -> Integer -> Integer
getExponent x e
    | ((x `mod` (2^(e + 1))) == 0) = getExponent x (e + 1)
    | otherwise = e

ruler :: Stream Integer
ruler = interleaveStreams odd even
  where
    odd = streamRepeat 0
    even = streamMap (\x -> getExponent x 0) $ streamFromSeed (+2) 2

-- Exercise 6 -- todo: Did not understand the instructions here

-- x :: Stream Integer
-- x = Cons 0 (Cons 1 (streamRepeat 0))

-- instance Num (Stream Integer) where
--     fromInteger n   = Cons n (Cons 1 (streamRepeat 0))
--     negate n        = streamMap (\c -> (-1) * c) n
--     -- n (+) m         = 