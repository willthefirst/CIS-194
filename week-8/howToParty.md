Emily's the boss/CEO of our company, aka Employee aka L1.
Company hierachy = L1 is highest, L2 is below that, etc.
F = the combined fun score of a given level

# IF Emily is coming 

## 1-level company => Just Emily, duh (this is a 1-person "company")

## 2-level company => Just Emily (Employee)

Invite whichever is bigger: L1s F or L2s F. 

## 3-level company => (Employee, and all Level 3s.)

Don't invite any level 2s, they'll have no fun because of Emily.
But, invite ALL level 3s, cuz their boss won't be there!

## 4-level company => (Employee, moreFun L3 L4)

Level 2s won't have any fun.
So invite all the level 3s? If we do, we can't shouldn't invite any level 4s...

IF the L4s F > L3s F THEN
    - Invite L4s, NOT L3s.
ELSE
    - Invite L3s, NOT L4s.

## 5-level company => (Employee, moreFun (L3s F + L5s F) (L4s F))

L2s won't have any fun, definitely not them.
L3s: 
    if we invite them, we can't invite any L4s, which means we CAN invite L5s.
    if we don't invite them, we can invite all the L4s no problem
    
    So which should we do?

    We should get whatever has the highest fun between
        (L3s F + L5s F) vs (L4s F)

## 6-level company => 
        (Employee, moreFun (L3s F + moreFun (moreFun L5 L6)) (L4s F + L6 F))

L2s: def not, no point
L3s:
    if we invite them, we can't invite L4s, but we CAN invite L5s OR L6s, whichever is greater.
    if we don't invite them, we can invite L4s AND L6s

    So which should we do?

    We should get whatever has the highest fun between
    (L3s F + (moreFun L5 L6)) vs (L4s F + L6 F)


# IF Emily is NOT coming 

## 2-level company => (L2s)

Invite all level 2s. Done.

## 3-level company => (moreFun L2s L3s)

Invite biggest F between L2s and L3s.

## 4-level company => (moreFun (L2s F + L4s F) L3s)

Great between (L2s F + L4s F) vs L3s F

...etc.