star' :: StarSemiring a => [[a]] -> [[a]]
star' xs = foldr f xs [0..length xs - 1]
  where
    f k xs = ys 
      where
        ~(ys, kk, row, col) = ifoldr fr (const ([[]],undefined,[],[])) xs col

        fr i xr c ~(ik:iks) = (zs : ys', kk'', bool row' xr (i == k), clv : col')
          where
            ~(ys', kk', row', col') = c iks
            ~(zs,kk'',clv) = ifoldr fc (const ([], kk', undefined)) xr row
            fc j x c ~(kj:kjs) = ((x <+> (ik <.> kk <.> kj)) : ys'', bool kk' (star x) (i == k && j == k), bool clv' x (j == k))
              where
                ~(ys'', kk', clv') = c kjs
                
                
import Data.List
import Data.Bool

class Semiring a where
    infixr 6 <+>
    infixr 7 <.>
    (<+>), (<.>) :: a -> a -> a
    one, zer :: a
    
instance Semiring Bool where
    (<+>) = (||)
    (<.>) = (&&)
    one = True
    zer = False
    
class Semiring a => StarSemiring a where
    star :: a -> a

instance StarSemiring Bool where
    star _ = True

star' :: StarSemiring a => [[a]] -> [[a]]
star' xs = foldr f xs [0..length xs - 1]
  where
    f k xs = zipWith (\ik ->  zipWith (\kj x -> x <+> (ik <.> kk <.> kj)) row) col xs
      where
        kk = star (xs !! k !! k)
        row = xs !! k
        col = map (!!k) xs

    
exampleGraph = 
  [ [False,True ,False,False,False]
  , [False,False,True ,False,False]
  , [False,False,False,True ,True]
  , [False,True ,False,False,False]
  , [False,False,False,True ,False] ]
  
printMatrix = mapM_ (putStrLn . concatMap (bool "0 " "* "))

import Data.List
import Data.Bool
import Data.Array

class Semiring a where
    infixr 6 <+>
    infixr 7 <.>
    (<+>), (<.>) :: a -> a -> a
    one, zer :: a
    
instance Semiring Bool where
    (<+>) = (||)
    (<.>) = (&&)
    one = True
    zer = False
    
class Semiring a => StarSemiring a where
    star :: a -> a

instance StarSemiring Bool where
    star _ = True
    
data R = Finite Rational | Inf deriving (Eq, Ord, Show)

instance Semiring R where
    Inf <+> _ = Inf
    _ <+> Inf = Inf
    Finite x <+> Finite y = Finite (x + y)
    Finite 0 <.> _ = Finite 0
    _ <.> Finite 0 = Finite 0
    Inf <.> _ = Inf
    _ <.> Inf = Inf
    Finite x <.> Finite y = Finite (x * y)
    one = Finite 1
    zer = Finite 0
    
instance StarSemiring R where
    star (Finite x) | x < 1 = Finite (x / (1 - x))
    star _ = Inf
    
instance Num R where
    fromInteger = Finite . fromInteger
    (+) = (<+>)
    (*) = (<.>)
    abs = id
    negate = id
    signum Inf = Finite 1
    signum (Finite x) = Finite (signum x)
    
instance Fractional R where
    fromRational = Finite
    Inf / Inf = 1
    Inf / _ = Inf
    _ / Inf = 0
    Finite x / Finite y = Finite (x / y)
    
    
memo :: (Bounded a, Ix a) => (a -> a -> b) -> a -> a -> b
memo f = curry (xs!)
  where
    bounds = ((minBound,minBound),(maxBound,maxBound))
    xs = listArray bounds (map (uncurry f) (range bounds))

star' :: (Bounded a, Ix a, StarSemiring b) => (a -> a -> b) -> a -> a -> b
star' xs = foldr f xs (range (minBound,maxBound))
  where
    f k xs = memo (\i j -> xs i j <+> xs i k <.> kk <.> xs k j)
      where
        kk = star (xs k k)
        
data Node = A | B | C | D | E | F | G deriving (Eq, Ord, Show, Bounded, Ix, Enum)

exampleGraph :: Node -> Node -> R
exampleGraph A B = 0.2
exampleGraph A A = 0.4
exampleGraph B C = 0.2
exampleGraph C D = 0.2
exampleGraph C E = 0.2
exampleGraph E D = 0.2
exampleGraph D B = 0.2
exampleGraph _ _ = 0

--star' :: StarSemiring a => [[a]] -> [[a]]
--star' xs = foldr f xs [0..length xs - 1]
--  where
--    f k xs = zipWith (\ik ->  zipWith (\kj x -> x <+> ik <.> kk <.> kj) row) col xs
--      where
--        kk = star (xs !! k !! k)
--        row = xs !! k
--        col = map (!!k) xs
--
toFun xs i j = xs !! i !! j
fromFun f = [ [ f i j | j <- range (minBound, maxBound) ] | i <- range (minBound, maxBound) ]
    
--exampleGraph = 
--  [ [False,True ,False,False,False]
--  , [False,False,True ,False,False]
--  , [False,False,False,True ,True]
--  , [False,True ,False,False,False]
--  , [False,False,False,True ,False] ]
  
--printMatrix = mapM_ (putStrLn . concatMap (bool "0 " "* ")) . fromFun