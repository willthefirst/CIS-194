{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Risk where

import Control.Monad.Random
import Control.Applicative
import Data.List
import Debug.Trace

------------------------------------------------------------
-- Die values

newtype DieValue = DV { unDV :: Int } 
  deriving (Eq, Ord, Show, Num)

first :: (a -> b) -> (a, c) -> (b, c)
first f (a, c) = (f a, c)

instance Random DieValue where
  random           = first DV . randomR (1,6)
  randomR (low,hi) = first DV . randomR (max 1 (unDV low), min 6 (unDV hi))

die :: Rand StdGen DieValue
die = getRandom

testDie :: IO DieValue
testDie = evalRandIO (die)
------------------------------------------------------------
-- Risk

type Army = Int

data Battlefield = Battlefield { attackers :: Army, defenders :: Army } deriving Show

-- 2

attackerRolls :: Army -> Rand StdGen [DieValue]
attackerRolls size
  | size < 2 = return []
  | otherwise  = reverse . sort <$> sequence rolls
      where rolls = replicate (min 3 (size - 1)) die

defenderRolls :: Army -> Rand StdGen [DieValue]
defenderRolls size
  | size < 1 = return []
  | otherwise  = reverse . sort <$> sequence rolls
      where rolls = replicate (min 2 size) die

summedResults :: [Ordering] -> (Int, Int)
summedResults rolls =
  foldr (\roll (a, d) -> 
    if roll == GT then 
      (a, (d + 1))
    else 
      (a + 1, d)) (0,0) rolls

battle :: Battlefield -> Rand StdGen Battlefield
battle (Battlefield a d) = do
  (aRolls, dRolls) <- return (attackerRolls a, defenderRolls d)
  rollResults <- return $ zipWith compare <$> aRolls <*> dRolls
  (aLosses, dLosses) <- summedResults <$> rollResults
  return (Battlefield (a - aLosses) (d - dLosses))

testBattle = evalRandIO (battle (Battlefield 3 2))

-- 3 

invade :: Battlefield -> Rand StdGen Battlefield
invade bf = do
  bf'@(Battlefield a d) <- battle bf
  if a < 2 || d < 1 then
    return bf'
  else
    invade bf'

testInvade = evalRandIO (invade (Battlefield 1 7))

-- 4
length' = fromIntegral . length

successProb :: Battlefield -> Rand StdGen Double
successProb bf = do 
  games <- replicateM 1000 (invade bf)
  aWins <- return (filter (\(Battlefield _ d) -> d == 0) games)
  return $ fromRational ((length' aWins) / (length' games))

testSuccessProb = evalRandIO $ successProb (Battlefield 21 21)  

