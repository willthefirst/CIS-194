While learning Haskell at RC, I've been learning how to work with a typed language.

Here's a common type in Haskell:

> data Maybe a = Just a | Nothing

--> Show the Javascript alternative.

Types allows us to 




LEFT OFF HERE: NEXT, TALK ABOUT THE NEED TO UNWRAP VALUES!


Quick reminder aboutfunctional programming syntax:

In Haskell,

> 2 + 2

is the same thing as

> (+2) 2
--> "a function that adds two to something."



But here's the issue:

> (+2) Just 2

or

> Just 5 + Nothing

How do we do things to the values that are wrapped in these types?





Like in other languages, how could we apply a function to a list?

> (+2) [2, 4]

That gives us an error. Here, we have the same problem as before: how do we perform an action on something's contents? 

> map (+2) [2, 4]

--> some sort of diagram here





This is true in plenty of languages. Mapping a function over a list applies the function to each element in the list and returns a new list.
"a list is a wrapper around values, as is a maybe/just/nothing"



Now, back to our initial issue:

How do we add 2 to Just 2

> (+2) Just 2

Fails. But, Haskell gives us `fmap`, a general function for running functions on the contents of a type.

> fmap (+2) (Just 2)

[diagram showing how the function gets applied to the inside of the type, just like with a List.]




Another syntax of the thing above:

> (+2) <$> (Just 2)
"apply the function +2 to the Just 2"

> (+2) <$> (Nothing)




((((( (maybe delete this)

And you can even get weirder with it and do something like this:

> (Just (+2)) <$> (Just 2)

Ie. what if we have a function wrapped in a type?

> (Just (+2)) <*> (Just 2)

[diagram showing how apply works, as compared to fmap]

Armed with <$> and <*> we can do even funkier stuff:

> (+) <$> (Just 2) <*> (Just 2)

[show the progression, evaluated from left to right.
= (Just (+2)) <*> (Just 2)

)))))


A final case: sometimes we have functions that return wrapped values. For example:

> lowerThanTen :: Int -> Maybe Int
> lowerThanTen i
  | i < 10    = Just i
  | otherwise = Nothing

> halve :: Int -> Maybe Int
> halve i =
  | even i    -> Just (n `div` 2)
  | otherwise -> Nothing

> lowerThanTen 2
> lowerThanTen 11

> halve 4
> halve 5

But what about 

> halve (lowerThan10 4) 
[show why this fails]
Fails. It would be nice to be able to feed wrapped values into functions that don't necessarily accept them.

[ show the fixed function above ]

"as programmers, we like to build big things from smaller things. in fp, we do this with composition, and these operators allow us to compose more things"

if time: btw you just learned was a monad is, and you can brag to all your friends about it.



---
Show a Javascript example of halvePerfectly:

// If an integer is even, halve it. Otherwise, fail.
function halvePerfectly(n) {
  if (n % 2 === 0) { return n / 2 }
  else             { return undefined }
}



[JS example of halvePerfectly, and how we can compose it]

> halvePerfectly :: Int -> Maybe Int
> halvePerfectly i = 
>  | even i    -> Just (n `div` 2)
>  | otherwise -> Nothing

> halvePerfectly(10) -- Just 5
> halvePerfectly(5) -- Nothing

Now, what chain this function?

> halvePerfectly(halvePerfectly(10))
[ Break down how this executes, and how Haskell complains that we're giving it a bad type]

We can do this in JS no problem because we don't have to worry about types.
But we like types! So how can we easily compose types, or wrapped, things?

> halvePerfectly 10 >>= halvePerfectly