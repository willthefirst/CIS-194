module Party where

import Employee
import GuestList

--1.1

glCons :: Employee -> GuestList -> GuestList
glCons e@(Emp { empFun = ef}) (GL es f) = GL (e:es) (ef + f) 

--1.2 --> see GuestList.hs

--1.3

moreFun :: GuestList -> GuestList -> GuestList
moreFun gl1 gl2
    | (compare gl1 gl2 == LT) = gl2
    | otherwise               = gl1
    
-- 2.