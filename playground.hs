import Control.Applicative

xRolls :: [Integer]
xRolls = [6, 2, 2]

yRolls :: [Integer]
yRolls = [5, 2, 1, 1, 2]

f :: [Ordering]
f = getZipList $ compare <$> ZipList xRolls <*> ZipList yRolls
