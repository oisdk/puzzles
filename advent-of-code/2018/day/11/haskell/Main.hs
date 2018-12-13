module Main (main) where

import Data.Array
import Data.Maybe

serial :: Int
serial = 4455

powerLevel :: Int -> Int -> Int
powerLevel x y =
  let rid = x + 10
  in (((((rid * y) + serial) * rid) `div` 100) `mod` 10) - 5

matrix :: Array (Int,Int,Int) Int
matrix =
    array
        ((1, 1, 1), (300, 300, 300))
        [ ((x, y, s), fn x y s)
        | x <- [1 .. 300]
        , y <- [1 .. 300]
        , s <- [1 .. 300] ]
  where
    fn x y 1 = powerLevel x y
    fn x y s =
        let t =
                sum
                    [ matrix ! (cx, y, 1)
                    | cx <- [x .. x + s - 1] ]
            l =
                sum
                    [ matrix ! (x, cy, 1)
                    | cy <- [y + 1 .. y + s - 1] ]
        in t + l + matrix ! (x + 1, y + 1, s - 1)

maximumOn :: Ord b => (a -> b) -> [a] -> a
maximumOn key xs = fromJust $ foldr f (fmap fst) xs Nothing
  where
    f x k Nothing = k (Just (x, key x))
    f x k ys@(Just (_, yk))
      | yk < xk = k (Just (x, xk))
      | otherwise = k ys
      where
        xk = key x


answer :: (Int, Int, Int)
answer =
    maximumOn
        (matrix !)
        [ (x, y, s)
        | s <- [1 .. 300]
        , x <- [1 .. 300 - s]
        , y <- [1 .. 300 - s] ]

main :: IO ()
main = print answer
