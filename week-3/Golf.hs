{-# OPTIONS_GHC -Wall #-}
module Golf where

-- Exercise 1

returnEvery :: Int -> [a] -> [a]
returnEvery _ [] = []
returnEvery n (x:xs) =
    x : returnEvery n (drop n xs)

skips :: [a] -> [[a]]
skips xs =
    map (\n -> returnEvery n (drop n xs)) [0..length xs - 1]

-- Exercise 2

localMaxima :: [Integer] -> [Integer]
localMaxima []          = []
localMaxima [a]         = []
localMaxima [a, b]      = []
localMaxima (a:b:c:rest)
    | (b > a && b > c)  = b : localMaxima (b:c:rest)
    | otherwise         = localMaxima (b:c:rest)

-- Exercise 3

histogram :: [Integer] -> String
histogram xs =
    renderRows $ map (\x -> length $ filter (==x) xs) [0..9]

renderRows :: [Int] -> String
renderRows [0,0,0,0,0,0,0,0,0,0] = "\n"
renderRows xs =
        renderRows
            $ map (\x ->
                if (x > 0) then
                    x - 1
                else
                    x
            ) xs

    -- [0,2,0,0,0,1,0,0,0,0]
    -- [0,1,0,0,0,0,0,0,0,0]
    -- [0,0,0,0,0,0,0,0,0,0] // if fold = 0, stop, otherwise continue





-- using filter, get the number of occurences of a number
    -- eg. length filter (==0) [0, 1, 0] -> 2

-- ==========
-- 0123456789

-- putStr (histogram [3,5])

-- unwords might be useful
