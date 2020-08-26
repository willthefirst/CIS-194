-- Exercise 1 [WORKS, BUT SEEMS COMPLICATED]

-- If it contains 2, 0. otherwise, multiplies every even (number - 2) together.
fun1' :: [Integer] -> Integer
fun1' = foldr (\x y -> (x-2) * y) 1 . filter even

fun2 :: Integer -> Integer
fun2 1 = 0
fun2 n 
    | even n    = n + fun2 (n `div` 2)
    | otherwise = fun2 (3 * n + 1)

fun2' :: Integer -> Integer
fun2' 2 = 0
fun2' x
    | odd x = fun2' (3 * x + 1)
    | otherwise =
        let
            halves = takeWhile even $ iterate (`div` 2) x
            notBase2 = last halves /= 2
        in
            if notBase2 then sum halves + (fun2' $ (last halves) `div` 2)
            else sum halves

-- We only add up even numbers.
-- If the even number isn't base 2, add up it's halves until we hit an odd number, then recurse.

-- fun2 3 -- Dang, 3 is odd. Inflate it to a bigger even number.
-- = fun2 (3 * 3 + 1) 
-- = fun2 (10)
-- = 10 +  fun2 (10 / 2)
--         = fun2 (5) -- Dang, 5 is odd. This means that 10 is not a number with base 2.
--         = fun2 (3 * 5 + 1)
--         = fun2 (16)
--         = 16 +  fun2 (16 / 2)
--                 = fun2 (8)
--                 = 8 +   fun2 (8/2)
--                         = fun2 (4)
--                         = 4 +   fun2 (2)
--                                 = 2 +   fun2 1
--                                         0

-- Exercise 2 [INCOMPLETE]

data Tree a = Leaf
            | Node Integer (Tree a) a (Tree a)
        deriving (Show, Eq)

foldTree :: [a] -> Tree a
foldTree [x] = Node 0 Leaf x Leaf
foldTree x:xs  =
    foldr (\y acc -> Node _ acc y ) foldTree [x] xs


    foldTree [x] -- Node 0 Leaf "A" Leaf


    foldr (\y acc -> Node _ foldTree y ) Leaf xs

-- "ABCDEFGHIJ"


-- old stuff

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
        
