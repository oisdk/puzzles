module Part2 where

import           Input

distance :: (Int, Int) -> (Int, Int) -> Int
distance (x1,y1) (x2,y2) = abs (x1 - x2) + abs (y1 - y2)

dists :: [(Int, Int)] -> Int
dists xs =
    length
        [ ()
        | y <- [0 .. 400]
        , x <- [0 .. 400]
        , sum (map (distance (x, y)) xs) < 10000 ]

main :: IO ()
main = print . dists =<< input
