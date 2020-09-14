module Party where

import Employee
import GuestList
import Data.Tree
import Debug.Trace
import System.IO

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

treeFold :: (a -> [b] -> b) -> b -> Tree a -> b
treeFold f i (Node {rootLabel = r, subForest = s})
  = f r (map (treeFold f i) s) 

-- 3

nextLevel :: Employee -> [(GuestList, GuestList)] -> (GuestList, GuestList)
nextLevel b@(Emp _ fun) gls = 
    foldr f (GL [b] fun, GL [] 0) gls
        where f = (\(gl1, gl2) acc -> (fst acc <> gl2 , snd acc <> (moreFun gl1 gl2)))

-- 4

testCompanyHere'
  = Node (Emp "Stan" 1)
    [ Node (Emp "Stewart" 9) []
    , Node (Emp "Fin" 2) []
    ]

maxFun :: Tree Employee -> GuestList
maxFun t = uncurry moreFun $ treeFold nextLevel (mempty, mempty) t

-- 5

main :: IO ()
main = do
    handle <- openFile "company.txt" ReadMode  
    contents <- hGetContents handle
    let bestGL = maxFun . stringToTree $ contents
    print bestGL  
    hClose handle  

stringToTree :: String -> Tree Employee
stringToTree s = read s