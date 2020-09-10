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
    
-- 2

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

-- 3

-- See howToParty.md for reasoning in English.

nextLevel :: Employee -> [(GuestList, GuestList)] -> (GuestList, GuestList)
-- L1 company When nobody but the boss (comes, doesn't come) to the party.
nextLevel 
    b@(Emp _ f) [((GL [] _), (GL [] _))]
        = (GL [b] f, mempty)
-- L2 company
nextLevel 
    b@(Emp _ f) [(_, l2s)]
        = (bossOnly, moreFun bossOnly l2s)
            where bossOnly = GL [b] f
-- L3 company
nextLevel
    b [(GL [] 0, l2s), (l3s, _)]
        = (glCons b l3s, moreFun l2s l3s)
-- L4+ company
nextLevel
    b ((GL [] 0, l2s):lsX)
        = ( glCons b (moreFun l3 l4 ) , $$$ )
        = ( snd ( nextLevel b lsX )   , $$$ )
        = ( snd ( nextLevel b [(l3,l3'), (l4, l4')])   , $$$ )
        = ( snd ( nextLevel b [(l3,l3'), (l4, l4')])   , $$$ )


boss ++ (greatest between l3s and l4s)

nextLevel: boss [(l3s, l3s'), (l4s, l4s')]
= 



-- Other tests
 
emily = Emp "Emily" 5
bob = Emp "Bob" 4
dave = Emp "Dave" 5

gl1 = GL [emily] 5
gl2 = glCons bob (glCons dave (GL [] 0))
gl3 = gl1 <> gl2
