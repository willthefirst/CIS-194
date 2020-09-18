{- CIS 194 HW 10
   due Monday, 1 April
-}

module AParser where

import           Control.Applicative()

import           Data.Char

-- A parser for a value of type a is a function which takes a String
-- representing the input to be parsed, and succeeds or fails; if it
-- succeeds, it returns the parsed value along with the remainder of
-- the input.
newtype Parser a = Parser { runParser :: String -> Maybe (a, String) }

-- For example, 'satisfy' takes a predicate on Char, and constructs a
-- parser which succeeds only if it sees a Char that satisfies the
-- predicate (which it then returns).  If it encounters a Char that
-- does not satisfy the predicate (or an empty input), it fails.
satisfy :: (Char -> Bool) -> Parser Char
satisfy p = Parser f
  where
    f [] = Nothing    -- fail on the empty input
    f (x:xs)          -- check if x satisfies the predicate
                        -- if so, return x along with the remainder
                        -- of the input (that is, xs)
        | p x       = Just (x, xs)
        | otherwise = Nothing  -- otherwise, fail

-- Using satisfy, we can define the parser 'char c' which expects to
-- see exactly the character c, and fails otherwise.
char :: Char -> Parser Char
char c = satisfy (== c)

{- For example:

*Parser> runParser (satisfy isUpper) "ABC"
Just ('A',"BC")
*Parser> runParser (satisfy isUpper) "abc"
Nothing
*Parser> runParser (char 'x') "xyz"
Just ('x',"yz")

-}

-- For convenience, we've also provided a parser for positive
-- integers.
posInt :: Parser Integer
posInt = Parser f
  where
    f xs
      | null ns   = Nothing
      | otherwise = Just (read ns, rest)
      where (ns, rest) = span isDigit xs

------------------------------------------------------------
-- Your code goes below here
------------------------------------------------------------

-- 1

first :: (a -> b) -> (a, c) -> (b, c)
first f (x, y) = (f x, y)

instance Functor Parser where
  fmap f (Parser p) = Parser (fmap (first f) . p)

-- 2

instance Applicative Parser where
  pure a = Parser (\s -> Just (a, s))
  p1 <*> p2 = Parser (\s ->
      case runParser p1 s of
        Nothing -> Nothing
        Just (f, s') -> runParser (f <$> p2) s'
    )


-- if p1 = char 'a'
--   then runParser p1 s = Just ('a', "bcd")

-- if p1 = 
--         runParser (  ) "abcd" = Just ((\x -> ('a' , x) ), "bcd") 

--   where p1 = (\maybeA -> 
--     | char maybeA == Nothing = Nothing
--     | otherwise = (\maybeB -> (maybeA, maybeB)))


-- !!   then runParser p1 s = Just ((\x -> ('a' , x) ), "bcd")

-- which is of type        
-- but we need it to type = __Just (f, "bcd") __ <<<< FIGURE THAT OUT !!

--                           Just ((\x -> ('a' , x) ), "bcd")


--                    (of form Just (f, s'))
-- knowing that we then need to run runParser (f <$> p2) s' 

-- runParser (f <$> p2) s' 
--           (Parser (fmap (first f) . p2)) s'

--                                                 char 'b' . s' $ "bcd"
--   when p1 = char 'a')         Just ('a', "bcd") Just ('b',"cd")
--   (when p1 = ______)  fmap (first f)            Just ('b',"cd")

-- i need to write a function where
  
--  f = x -> ('a' , x)  

-- runParser (fmap f p2) s'
-- runParser (fmap __ (char 'b') ) "bcdef"

-- runParser p1 s
-- runParser (fmap (\c -> (\_ -> (c, 'b'))) (char 'a') ) $ "abcdef" 
-- ...
-- Just (f, s')


-- ap = (fmap (\c -> (\_ -> (c, 'b'))) (char 'a') ) $ "abcdef" 
-- bp = (char 'b')
-- abp = ap <*> bp ("abcdef")
-- Parser (p -> (Char, Char)) -> Parser Char -> Parser (Char, Char)

-- 3

abParser :: Parser (Char, Char)
abParser = checkForA <*> (char 'b')
  where checkForA = Parser testForA
        
testForA :: String -> Maybe ((Char -> (Char, Char)), String)
testForA s =
  case runParser (char 'a') s of
      Just ('a', rest) -> Just (\maybeB -> ('a', maybeB), rest)
      _ -> Nothing
  