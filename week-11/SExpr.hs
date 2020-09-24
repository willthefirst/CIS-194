{- CIS 194 HW 11
   due Monday, 8 April
-}

module SExpr where

import AParser
import Control.Applicative
import           Data.Char
import Debug.Trace

------------------------------------------------------------
--  1. Parsing repetitions
------------------------------------------------------------

zeroOrMore :: Parser a -> Parser [a]
zeroOrMore p = oneOrMore p <|> pure []

oneOrMore :: Parser a -> Parser [a]
oneOrMore p = liftA2 (++) ((fmap (\x -> [x]) p)) (zeroOrMore p)

------------------------------------------------------------
--  2. Utilities
------------------------------------------------------------

spaces :: Parser String
spaces = zeroOrMore (satisfy isSpace)

ident :: Parser String
ident = liftA2 (++) (oneOrMore (alphas)) (zeroOrMore (alphaNums))
  where alphas = satisfy isAlpha
        alphaNums = satisfy isAlphaNum

------------------------------------------------------------
--  3. Parsing S-expressions
------------------------------------------------------------

-- An "identifier" is represented as just a String; however, only
-- those Strings consisting of a letter followed by any number of
-- letters and digits are valid identifiers.
type Ident = String

-- An "atom" is either an integer value or an identifier.
data Atom = N Integer | I Ident
  deriving Show

-- An S-expression is either an atom, or a list of S-expressions.
data SExpr = A Atom
           | Comb [SExpr]
  deriving Show

parseAtom :: Parser Atom
parseAtom = N <$> posInt 
            <|> I <$> ident

parseComb :: Parser [SExpr]
parseComb = (open *> oneOrMore (parseSExpr) <* close)
  where open   = char '('
        close  = char ')'

parseSExpr :: Parser SExpr
parseSExpr =  A <$> (spaces *> parseAtom) <* spaces
              <|> Comb <$> (spaces *> parseComb) <* spaces