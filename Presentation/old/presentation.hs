{-# LANGUAGE GeneralizedNewtypeDeriving #-}

-- Haskell lets us describe things nicely using datatypes.
-- In this case, let's say a Bar can either be Closed or Serving a, where a could be anything: int, string, etc. 
data Bar a = Closed | Serving a
    deriving Show

openBar :: Bar [String]
openBar = Serving ["taro", "dan", "jacob"]
closedBar = Closed

-- Cool. So how can I add a customer to the bar? Unfortunately, this won't work:

-- newBar = openBar ++ ["jim"]
            -- (Bar [String])  [String]
-- (++) expects list types, and doesn't know what to do with a `Bar [String]`

-- So how can we do this simple thing while preserving our lovely `Bar` datatype?
-- Enter: functors

instance Functor Bar where
    fmap f Closed       = Closed
    fmap f (Serving a)  = Serving (f a)

-- Let's also write a little that adds a single customer to the bar.
addCustomers :: [String] -> Bar [String] -> Bar [String]
addCustomers customers bar = fmap (++ customers) bar

openBar' = addCustomers ["jim"] openBar
closedBar' = addCustomers ["jim"] closedBar

-- OK LOVELY. Now I want a function that will move all the folks from one bar to another bar.
-- For this, I need applicatives.
-- (show why you can't accomplish this purely with fmap) 
instance Applicative Bar where
    pure f = Serving f 
    Closed <*> f = Closed
    Serving f <*> x = fmap f x

-- Move all the customers from one bar to another bar
addCustomers' :: Bar [String] -> Bar [String] -> Bar [String]
addCustomers' b1 b2 = fmap (++) b1 <*> b2
-- todo: This part feels like a bit of a leap, that function is doing some trickery that might be hard to explain.

a = addCustomers' (Serving (["jim"])) (Serving ["taro"])

-- OK lovely. Functors would let us apply unwrapped values to wrapped values, and now applicatives will let us apply wrapped values to wrapped values.
-- But realistically, customers will be coming all night, and I'll have to call this function repeatedly, chained, if you will.

x = addCustomers' (Serving ["jacob"]) (addCustomers' (Serving ["jim"]) (Serving ["taro"]))

instance Monad Bar where  
    return x        = Serving x  
    Closed >>= f    = Closed  
    Serving x >>= f = f x  

addCustomers'' :: [String] -> [String] -> Bar [String]
addCustomers'' customers bar = 
    if length (customers ++ bar) < 3 then
        return (customers ++ bar)
    else
        Closed

y = return ["ads"] >>= addCustomers'' ["taro"] >>= addCustomers'' ["will", "jacob"]


-- When working with types, we want to run functions on the information that the type "contains."
-- Functors: allow us to run a function on the contents of a type, returning something of that type.
-- Applicatives: allow us to the contents of a type on the contents of another type.
-- Monads: allows us to feed the contents of a type into a function that doesn't accept that type

data Milk a = Spill | Cup a
    deriving Show

instance Functor Milk where
    fmap f Spill    = Spill
    fmap f (Cup a)  = Cup (f a)

instance Applicative Milk where
    pure f = Cup f 
    Spill <*> f = Spill
    Cup f <*> x = fmap f x

instance Monad Milk where  
    return x    = Cup x  
    Spill >>= f = Spill  
    Cup x >>= f = f x  

pour5 :: Integer -> Milk Integer
pour5 i =
    if (i > 10) then
        Spill
    else
        return (i + 5)

drink = return 0 >>= pour5 >>= pour5 >>= pour5 >>= pour5

-- Without the monad

pour5'  :: Milk Integer -> Milk Integer
pour5' Spill = Spill
pour5' (Cup i) = 
    if i > 10 then Spill
    else Cup (i + 10)

x -: f = f x

drink' = Cup 0 -: pour5' -: pour5'
