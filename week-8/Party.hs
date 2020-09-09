module Party where

import Employee
import GuestList
import Data.Tree

--1.1

glCons :: Employee -> GuestList -> GuestList
glCons e@(Emp { empFun = ef}) (GL es f) = GL (e:es) (ef + f) 

--1.2

--See GuestList.hs

--1.3

moreFun :: GuestList -> GuestList -> GuestList
moreFun gl1 gl2
    | (compare gl1 gl2 == LT) = gl2
    | otherwise               = gl1
    
-- 2.

treeFold :: (b -> a -> b) -> b -> Tree a -> b
treeFold f z (Node l [])        = f z l
treeFold f z (Node l [t])       = treeFold f (f z l) t 
treeFold f z (Node l (t:ts))    = foldl (\acc x -> (treeFold f acc x)) (treeFold f (f z l) t) ts

testTree :: Tree Int
testTree = (Node 2
        [ Node 3 []
        , Node 10 []
        ]
    )

testTreeFold = treeFold (\acc t -> acc + t) 0 testTree 
-- = foldl (\acc x ->      (treeFold f    acc         x)) (treeFold f (f z l)       t)            ts
-- = foldl (\acc x ->      (treeFold f    acc         x)) (treeFold f (f 0 2) (Node 3 [])) [(Node 10 [])]
-- = foldl (\acc x ->      (treeFold f    acc         x)) (treeFold f (  2  ) (Node 3 [])) [(Node 10 [])]
-- = foldl (\acc x ->      (treeFold f    acc         x)) (               5              ) [(Node 10 [])]
-- = (\5 (Node 10 []) ->   (treeFold f    5 (Node 10 [])))
-- = (treeFold f (f 5 2) (Node 10 [])))
-- = 
