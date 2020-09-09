module GuestList where

import Data.Monoid
import Employee

-- A type to store a list of guests and their total fun score.
data GuestList = GL [Employee] Fun
  deriving (Show, Eq)

instance Ord GuestList where
  compare (GL _ f1) (GL _ f2) = compare f1 f2

instance Semigroup GuestList where
  (<>) (GL gl1 f1) (GL gl2 f2) = GL (gl1 ++ gl2) (f1 + f2) 

instance Monoid GuestList where
  mempty  = GL [] 0 