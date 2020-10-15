build-lists: true
autoscale: true

# From Javascript to Haskell 
## Dealing With Types When I Didn't Have To Before


---


Learning Haskell was my first experience dealing with a statically typed language.

Let's translate something from JavaScript to Haskell, and look at how Haskell gives us flexibility despite its strict type system.


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
//  =   4

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

# Let's make all that stuff happen in Haskell.

---

First attempt: adding the type signature.

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
        halvePerfectly 8
--  =   4

        halvePerfectly 9
--  =   ERROR containing a bunch of confusing
--      stuff about how much the compiler
--      hates undefined
```


---


Yikes. Using `undefined` in Haskell ain't so great.

But, Haskell has a way of handling this common situation: the type `Maybe`.

```haskell
    data Maybe a = Just a | Nothing
```

In English, the above says that something is of type `Maybe` if it's value is either

`Just a` <sub>(where `a` means all types: integers, strings, booleans, etc.)</sub> 
or
`Nothing`.

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

```haskell
halvePerfectly :: Integer -> Integer
halvePerfectly i
    | (i `mod` 2 == 0) = i `div` 2
    | otherwise        = undefined
```


---
Let's rewrite our function using the `Maybe` type.

Instead of returning something of type `Integer`, let's return something of type `Maybe Integer`.

```haskell
halvePerfectly :: Integer -> Maybe Integer
halvePerfectly i
    | (i `mod` 2 == 0) = Just (i `div` 2)
    | otherwise        = Nothing
```

---
[.code-highlight: 1-4]
[.code-highlight: 1-8]
[.code-highlight: 1-10]
[.code-highlight: 1-19]
[.code-highlight: 1-20]
[.code-highlight: 1-21]
[.code-highlight: 1-27]
[.code-highlight: 1-35]


```haskell
halvePerfectly :: Integer -> Maybe Integer
halvePerfectly i
    | (i `mod` 2 == 0) = Just (i `div` 2)
    | otherwise        = Nothing

        halvePerfectly 8
--  =   Just 4

        halvePerfectly 3
--  =   Nothing

        halvePerfectly (halvePerfectly 8)
--  =   halvePerfectly (     Just 4     )
--  =   ERROR: Couldn't match expected type 
--      `Integer' with actual type `Maybe Integer' 
--      You should've thought about that before,
--      you JavaScript dolt.

-- `halvePerfectly` expects an argument of type `Integer`, but now we're feeding it something of type `Maybe Integer`.
-- Can we "unwrap" that `Integer` from the `Maybe` before feeding into `halvePerfectly`?
-- YES YES YES: using `>>=` (a.k.a) "bind"

       halvePerfectly 8 >>= halvePerfectly -- Just 4
--  =   (    Just 4    ) >>= halvePerfectly
--  =   `>>=` magically unwraps the `Just 4`, feeding only `4` to our function
--  =   Just 2

-- And guess what else: `>>=` also knows how to handle `Nothing`.
        halvePerfectly 10 >>= halvePerfectly >>= halvePerfectly
--  =   (    Just 5     ) >>= halvePerfectly >>= halvePerfectly
--  =   (              Nothing             ) >>= halvePerfectly
--  =   more magic... learn haskell if you really want to know
--  =   Nothing
```

---


![left 50%](1200px-Haskell-Logo.svg.png)

- This is one of *many* ways to work happily with types in Haskell.
- Also, I DISCOVERED that the bind operator `>>=` sure looks a lot like the Haskell logo?
    - That's a talk for another time.
- Now you can tell your friends that you know what a monad is. Don't worry about what that means, just tell them.


---


# THE END[^1]

[^1]: Thank you so much to Taro Kuriyama, Jim Carlson, Justin Holzmann, the Functional Programming study group and the #haskell Zulip stream for your support and guidance.