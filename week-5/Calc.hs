{-# LANGUAGE FlexibleInstances #-}

module Calc where

import ExprT
import Parser
import qualified Data.Map as M

-- Exercise 1

eval :: ExprT -> Integer
eval (Lit x)    = x
eval (Add x y)  = eval x + eval y
eval (Mul x y)  = eval x * eval y


-- Exercise 2

evalStr :: String -> Maybe Integer
evalStr x = 
    case (parseExp Lit Add Mul x) of
        Just x  -> Just $ eval x
        Nothing -> Nothing

-- Exercise 3

class Expr a where
    lit :: Integer -> a
    add :: a -> a -> a
    mul :: a -> a -> a

reify :: ExprT -> ExprT
reify x = x

instance Expr ExprT where
    lit x   = Lit x
    add x y = Add x y
    mul x y = Mul x y

-- Exercise 4

instance Expr Integer where
    lit x   = x
    add x y = x + y
    mul x y = x * y

instance Expr Bool where
    lit x 
        | x <= 0    = False
        | otherwise = True
    add x y = x || y
    mul x y = x && y

newtype MinMax = MinMax Integer deriving (Eq, Show, Ord)
instance Expr MinMax where
    lit x   = MinMax x
    add x y = if x > y then x else y
    mul x y = if x <= y then x else y

newtype Mod7 = Mod7 Integer deriving (Eq, Show)
instance Expr Mod7 where
    lit x   = Mod7 (x `mod` 7)
    add (Mod7 x) (Mod7 y) = Mod7 $ (x + y) `mod` 7
    mul (Mod7 x) (Mod7 y) = Mod7 $ (x * y) `mod` 7

testExp :: Expr a => Maybe a
testExp = parseExp lit add mul "(3*-4) + 5"

testInteger  = testExp :: Maybe Integer
testBool     = testExp :: Maybe Bool
testMM       = testExp :: Maybe MinMax
testMod7     = testExp :: Maybe Mod7

-- Exercise 6

class HasVars a where
    var :: String -> a

data VarExprT = VarLit Integer
           | VarAdd VarExprT VarExprT
           | VarMul VarExprT VarExprT
           | Var String
  deriving (Show, Eq)

instance HasVars VarExprT where
    var x = Var x

instance Expr VarExprT where
    lit x   = VarLit x
    add x y = VarAdd x y
    mul x y = VarMul x y

-- Couldn't figure out this last section

-- instance HasVars (M.Map String Integer -> Maybe Integer) where
--     var key map =  M.lookup key map

-- instance Expr (M.Map String Integer -> Maybe Integer) where
--     lit x map = Just x
--     add x y map = M.lookup x map + M.lookup lit y map
--     mul x y map =  x


