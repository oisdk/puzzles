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
        ((1, 0, 0), (299, 299, 299))
        [ ((s, y, x), fn s y x)
        | s <- [1 .. 299]
        , y <- [0 .. 299]
        , x <- [0 .. 299] ]
  where
    fn 1 y x = powerLevel (x + 1) (y + 1)
    fn s y x =
        let t =
                sum
                    [ matrix ! (1, y, cx)
                    | cx <- [x .. x + s - 1] ]
            l =
                sum
                    [ matrix ! (1, cy, x)
                    | cy <- [y + 1 .. y + s - 1] ]
        in t + l + matrix ! (s - 1, y + 1, x + 1)

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
        (\(x,y,s) ->
              matrix ! (s, y, x))
        [ (x, y, s)
        | s <- [1 .. 299]
        , x <- [0 .. 299 - s]
        , y <- [0 .. 299 - s] ]

main :: IO ()
main = print answer
