isEven :: Int -> Maybe Int
isEven n
    | (n `mod` 2 == 0) = Just n
    | otherwise = Nothing