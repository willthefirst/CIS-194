build-lists: true
autoscale: true

# From Javascript to Haskell: 
## Dealing With Types When I Didn't Have To Before


---


- I’ve only ever worked in JavaScript.
- JavaScript didn’t ask me to think too hard about types. 
    - It was great.
- I started learning Haskell 7 weeks ago.
- Haskell cares a whole lot about types.
    - Now I have to think about this.
- But people tell me that types are actually great to have. I’ll take their word for it.
- But, I have to admit, Haskell has some cool tools for handling types. I’m going to show you one of them.


---


First, in JavaScript, let's write a function that halves even numbers and ignores odd numbers.

[.column]
```js
function halvePerfectly (n) {
  if (n % 2 === 0) { return n / 2 }
  else             { return undefined }
}
```

[.column]
```js
//      It works for even numbers.
        halvePerfectly(8);
//      = 4

//      It fails for odd numbers.
        halvePerfectly(3);
//  =   undefined

//      We can even compose the function with itself.
        halvePerfectly(halvePerfectly(8));
//  =   halvePerfectly(        4        );
//  =   2

        halvePerfectly(halvePerfectly(5));
//  =   halvePerfectly(    undefined    )
//  =   undefined
```

---


Let's convert this to Haskell. 

[.column]
##### JavaScript
```js
function halvePerfectly (n) {
  if (n % 2 === 0) { return n / 2 }
  else             { return undefined }
}
```

[.column]
##### Haskell
```haskell
halvePerfectly :: Integer -> Integer
halvePerfectly i
    | (i `mod` 2 == 0) = i `div` 2
    | otherwise        = undefined
```

^ The only important difference here is that type declaration at the top. 
This syntax means that `halvePerfectly` takes one argument of type `Integer`, and then something of type `Integer`.


---


Let's try running it:

[.column]
```haskell
halvePerfectly :: Integer -> Integer
halvePerfectly i
    | (i `mod` 2 == 0) = i `div` 2
    | otherwise        = undefined
```

[.column]
```haskell
        halvePerfectly(8)
--  =   8

        halvePerfectly(3)
--  =   ERROR containing a bunch of confusing
--      stuff about how much the compiler
--      hates undefined
```


---


Yikes. Using `undefined` in Haskell ain't so great.

Haskell has a way of handling this common situation that comes up often: the built-in type `Maybe`, which is defined like this:

```haskell
 data Maybe a = Just a | Nothing
```

In English, the above says that something is of type `Maybe` if it's value is either

`Just a` <sub>(where `a` means all types (integers, strings, booleans, etc.</sub>), 
or
`Nothing`.


---


All the following are values of type `Maybe`.

```haskell
Just 4 -- Maybe Integer
Just True -- Maybe Bool
Just "Hello, world" -- Maybe String
Nothing -- Maybe a
```

---


Let's rewrite our function using the `Maybe` type.

Instead of returning something of type `Integer`, let's return something of type `Maybe Integer`.

[.column]
```haskell
halvePerfectly :: Integer -> Integer
halvePerfectly i
    | (i `mod` 2 == 0) = i `div` 2
    | otherwise        = undefined
```

[.column]
```haskell
halvePerfectly :: Integer -> Maybe Integer
halvePerfectly i
    | (i `mod` 2 == 0) = Just (i `div` 2)
    | otherwise        = Nothing

halvePerfectly(8) -- Just 8
halvePerfectly(3) -- Nothing
```


---


Now we have a function that doesn't deliver terrible errors, but there's one issue: we can't compose it with itself like before.

```haskell
halvePerfectly :: Integer -> Maybe Integer
halvePerfectly i
    | (i `mod` 2 == 0) = Just (i `div` 2)
    | otherwise        = Nothing
```

```haskell
        halvePerfectly (halvePerfectly 8)
--  =   halvePerfectly (     Just 4     )
--  =   ERROR: Couldn't match expected type 
--      `Integer' with actual type `Maybe Integer' 
--      You should've thought about that before,
--      you JavaScript dolt.
```

- This is actually reasonable. `halvePerfectly` expects an argument of type `Integer`, but now we're feeding it something of type `Maybe Integer`.

- Think of `Maybe` as a "wrapper" that holds an `Integer`. Can we "unwrap" that `Integer` from the `Maybe` before feeding into `halvePerfectly`? Is that a leading question? Is the answer probably yes? Should we go to the next slide?


---


# YES YES YES YES

Haskell gives us the `>>=` operator (a.k.a "bind") that does just that:

```haskell
halvePerfectly :: Integer -> Maybe Integer
halvePerfectly i
    | (i `mod` 2 == 0) = Just (i `div` 2)
    | otherwise        = Nothing
```

```haskell
        halvePerfectly 8 >>= halvePerfectly -- Just 4
--  =   (    Just 4    ) >>= halvePerfectly
--  =   🧙 `>>=` magically unwraps the `Just 4`, feeding only `4` to our function
--  =   Just 2

-- And guess what else: `>>=` also knows how to handle `Nothing`.
        halvePerfectly 5 >>= halvePerfectly
--  =   (    Nothing   ) >>= halvePerfectly
--  =    🧙 more magic... learn haskell if you really want to know
--  =   Nothing
```


---


![left 50%](1200px-Haskell-Logo.svg.png)

- Pretty magical, right? That `>>=` is pretty cool. 
- Also, I DISCOVERED that the bind operator sure looks a lot like the Haskell logo?
- That's a talk for another time.
- This is one of *many* ways to work happily with types in Haskell.
- Also, now you can tell your friends that you know what a monad is. Don't worry about what that means, just tell them.


---


# THE END[^1]

[^1]: Thank you so much to Taro Kuriyama, Jim Carlson, the Functional Programming study group and the #haskell Zulip stream for your support and guidance.