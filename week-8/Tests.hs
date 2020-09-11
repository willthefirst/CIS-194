module Tests where

import Employee
import GuestList
import Party


emily = Emp "Emily" 5
bob = Emp "Bob" 4
dave = Emp "Dave" 5
dan = Emp "Dan" 100 
fred = Emp "Fred" 10
hitler = Emp "Hitler" 1

-- Other tests

-- Testing nextLevel from Ex. 3

    -- [ Node (Emp "Emily" 5)
    --   [ Node (Emp "Bob" 4)
    --     [ Node (Emp "Dave" 5) []
    --     , Node (Emp "Dan" 100) []
    --     ]
    --   , Node (Emp "Fred" 10) [
    --         Node (Emp "Hitler" 1)
    --     ]
    --   ]

bestWithBob = glCons bob (GL [] 0)
bestWithoutBob = glCons dan $ glCons dave (GL [] 0) 
bobsBestLists = (bestWithBob, bestWithoutBob)

bestWithFred = glCons fred (GL [] 0)
bestWithoutFred = glCons hitler (GL [] 0)
fredsBestLists = (bestWithFred, bestWithoutFred)

testNextLevel = nextLevel emily [bobsBestLists, fredsBestLists]