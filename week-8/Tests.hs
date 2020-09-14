module Tests where

import Data.Tree
import Employee
import GuestList
import Party
import Debug.Trace

-- A small company hierarchy to use for testing purposes.
testCompany :: Tree Employee
testCompany
 = Node (Emp "Stan" 9) --
    [ Node (Emp "Bob" 2)
      [ Node (Emp "Joe" 5) --
        [ Node (Emp "John" 1) []
        , Node (Emp "Sue" 5) [] --
        ]
      , Node (Emp "Fred" 3) []
      ]
    , Node (Emp "Sarah" 17) --
      [ Node (Emp "Sam" 4) []
      ] 
    ]

testCompany2 :: Tree Employee
testCompany2
  = Node (Emp "Stan" 9)
    [ Node (Emp "Bob" 3) -- (8, 8) $$$$$
      [ Node (Emp "Joe" 5) -- (5, 6)
        [ Node (Emp "John" 1) [] -- (1, 0)
        , Node (Emp "Sue" 5) [] -- (5, 0)
        ]
      , Node (Emp "Fred" 3) [] -- (3, 0)
      ]
    , Node (Emp "Sarah" 17) -- (17, 4)
      [ Node (Emp "Sam" 4) [] -- (4, 0)
      ]
    ]

testTree :: Tree Int
testTree = (Node 2
        [ Node 3 []
        , Node 10 
            [ Node 11 
                [ Node 12 
                  [ Node 1000 []
                  ]
                ]
            ]
        ]
    )
    
-- Some more test cases

testCompanyL1 :: Tree Employee
testCompanyL1
  = Node (Emp "Grandma" 2) 
    [
      Node (Emp "Ma" 3) 
      [
        Node (Emp "Me" 0) []
      ]
    ]


testCompanyL1' :: Tree Employee
testCompanyL1'
  = Node (Emp "Stan" 1)
    [ Node (Emp "Stewart" 2) []
    , Node (Emp "Fin" 5) []
    ]

testCompanyL2 :: Tree Employee
testCompanyL2
  = Node (Emp "Stan" 9)
    [ Node (Emp "Bob" 3) []
    , Node (Emp "Sarah" 17) []  
    ]

testCompanyL3 :: Tree Employee
testCompanyL3
  = Node (Emp "Stan" 9)
    [ Node (Emp "Bob" 2)
      [ Node (Emp "Joe" 5) []
      , Node (Emp "Fred" 3) []
      ]
    , Node (Emp "Sarah" 17) []
    ]

-- Other tests

emily = Emp "Emily" 5
bob = Emp "Bob" 4
dave = Emp "Dave" 5
dan = Emp "Dan" 100 
fred = Emp "Fred" 10
hitler = Emp "Hitler" 1

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

-- Exercise four
-- testMaxFun = maxFun testCompanyL1'