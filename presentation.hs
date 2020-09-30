{-# LANGUAGE GeneralizedNewtypeDeriving #-}

-- Noise is just an integer.
-- Customers are just a list of noises.

type Noise = Integer
type Customers = [Noise] 

addNoise :: Noise -> Customers -> Customers
addNoise n cs = cs ++ [n]

-- Helper function so that we can write some lovely chains.
x -: f = f x

-- [10] -: addNoise 30 -: addNoise 40

data Bar a = Closed | Serving a
    deriving Show

addNoise' :: Noise -> Customers -> Bar Customers
addNoise' n cs 
    | sum newCustomers > 100 = Closed 
    | otherwise              = Serving newCustomers
        where newCustomers = cs ++ [n]

-- addNoise' 10 [20, 30]
-- addNoise' 10 [20, 30, 60]

-- But now, we can't chain our functions together. How can we both use our lovely new datatype AND chain our functions?

instance Functor Bar where
    fmap f Closed = Closed
    fmap f (Serving a) = Serving (f a)
-- todo: what does ^this^ definition allow us to do?

instance Applicative Bar where
    pure f = Serving f 
    Closed <*> f = Closed
    Serving f <*> x = fmap f x
-- todo: what does ^this^ definition allow us to do?

instance Monad Bar where  
    return x        = Serving x  
    Closed >>= f    = Closed  
    Serving x >>= f = f x  

-- return [20] >>= addNoise' 30 >>= addNoise' 50



-- -- x = Noise 10
-- -- y = Shh

-- -- But what if I want to do something with that "wrapped value"?
-- -- For example, I can't do this because of the type mismatch:

-- -- volumeUpdate = (Noise 10) + 30
-- -- volumeUpdate2 = (Noise 10) + (Noise 40)

-- -- I want to write a function that will "add noise" to the room.
-- -- But how do I add to this special wrapped type?
-- -- Functors, baby.

-- instance Functor Volume where
--     fmap f Shh        = Shh
--     fmap f (Noise x)  = Noise (f x) 



-- -- chainedEx1 = addNoise 10 (addNoise 10 (Noise 30))
-- -- chainedEx2 = Noise 10 -: addNoise 30 -: addNoise 50

-- -- However, when the volume exceeds 100, we get a Shh. We need to represent this.
-- -- Let's update our `addNoise` function:

-- addNoise2 :: Integer -> Volume Integer -> Volume Integer
-- addNoise2 n v
--     | fmap (>100) (fmap (+n) v) = Shh




-- -- But I'd also like to be able to combine these nice data types.
-- -- For example, this won't work:
-- -- x'' = fmap (+ (Noise 10)) Noise 20
-- -- How do I do this? Applicatives.

-- instance Applicative Volume where
--     pure f                = Noise f 
--     Shh <*> _             = Shh
--     Noise f <*> something  = fmap f something

-- -- j :: Volume Integer
-- -- j = (Noise (+10)) <*> Noise 20
-- -- j2 = fmap (+) (Noise 30) <*> (Noise 90)

-- -- OK sweeet. Now I can add these datatypes together.
-- -- 

-- instance Monad Volume where
--     return f = Noise fy
