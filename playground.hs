import Debug.Trace


x :: Integer
x = 1

f :: Integer
f = (trace ("here's x" ++ show x) x) + 1