-- Exercise 1

-- If it contains 2, 0. otherwise, multiplies every even (number - 2) together.
fun1 :: [Integer] -> Integer
fun1 = foldr (\x y -> (x-2) * y) 1 . filter even