-- Exercise 1

-- If it contains 2, 0. otherwise, multiplies every even (number - 2) together.
fun1' :: [Integer] -> Integer
fun1' = foldr (\x y -> (x-2) * y) 1 . filter even

fun2 :: Integer -> Integer
fun2 1 = 0
fun2 n 
    | even n    = n + fun2 (n `div` 2)
    | otherwise = fun2 (3 * n + 1)

fun2' :: Integer -> Integer
fun2' x = x + 4

-- We only are adding up even numbers. The lowest even numbers that come as result of 3*n + 1 + all power of 2 numbers for lowest possible 3*n. 
-- If it's a power of 2, we can iterate iterate powers of 2 from 2, and take everything that's smaller than n, and add it up.
-- else, 3*n + 1, 

-- fun2 3
-- = fun2 (3 * 3 + 1)
-- = fun2 (10)
-- -- It was odd, so we multiplied by 3 and incremented by 1 (to get an even number)
-- = 10 +  fun2 (10 / 2)
--         = fun2 (5) -- when divided by 2, we hit a prime, 5.
--         = fun2 (3 * 5 + 1)
--         = fun2 (16)
--         = 16 +  fun2 (16 / 2)
--                 = fun2 (8)
--                 = 8 +   fun2 (8/2)
--                         = fun2 (4)
--                         = 4 +   fun2 (2)
--            log                     = 2 +   fun2 1
--                                         0

-- fun2 4
-- = 4 + fun2 (2)
-- = 4 + (2 + fun2 1)
-- = 4 + (2 + 0)
-- = 6


-- If x odd, it turned even by being * 3 and + 1.
-- If x even, x + fun 2 (x - 2)
--      If x == 2^n, giving us x^n + x^n-1 + x^n-2 etc. 
--      Otherwise, x/2 repeatedly until x is odd, then try again.

-- Exercise 2

-- data Tree a = Leaf
--             | Node Integer (Tree a) a (Tree a)
--         deriving (Show, Eq)

-- half :: [a] -> ([a],[a])
-- half [] = ([],[])
-- half xs = splitAt ((length xs) `div` 2) xs

-- treeHeight :: [a] -> Integer
-- treeHeight [] = 0
-- treeHeight xs = modder (length xs)

-- modder :: Int -> Integer
-- modder 0 = 0
-- modder x = toInteger (fromIntegral 1 + modder (floor (x / 2)))

-- foldTree :: [a] -> Tree a
-- foldTree [] = Leaf
-- foldTree (x:xs) =
--     (Node (treeHeight xs) (foldTree (fst (half xs))) x (foldTree (snd (half xs))))


-- Exercise 3

-- 1.
xor :: [Bool] -> Bool
xor = foldr (/=) False . filter (==True)

-- 2.
map' :: (a -> b) -> [a] -> [b]
map' f xs = foldr (\x acc -> f x : acc) [] xs

-- Exercise 4

cartProd :: [a] -> [b] -> [(a, b)]
cartProd xs ys = [(x,y) | x <- xs, y <- ys]

-- Given n, generate all the odd prime numbers up to 2n+2
sieveSundaram :: Integer -> [Integer]
sieveSundaram n =
    let
        deplorables = 
            filter (<=n) 
            . map (\(i, j) -> i + j + (2 * i * j)) 
            $ cartProd [1, 2] [1..n]
        lovelies = 
            foldl (\acc x -> if notElem x deplorables then acc ++ [x] else acc) [] 
            $ [1..(2 * n + 1)]
    in
        takeWhile (<2 * n + 2)
        . foldl (\acc x -> acc ++ [2*x+1]) [] $ lovelies
        
