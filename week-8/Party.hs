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
treeFold f z (Node r [])        = f z r
treeFold f z (Node r [t])       = treeFold f (f z r) t 
treeFold f z (Node r (t:ts))    = foldl (\acc -> (treeFold f acc)) (treeFold f (f z r) t) ts

testTree :: Tree Int
testTree = (Node 2
        [ Node 3 []
        , Node 10 
            [ Node 11 
                [ Node 12 []
                ]
            ]
        ]
    )

testTreeFold = treeFold (\acc t -> acc + t) 0 testTree 