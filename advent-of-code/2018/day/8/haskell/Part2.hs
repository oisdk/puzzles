module Part2 where

import Data.Tree
import Data.Maybe
import Input

value :: Tree [Int] -> Int
value (Node x []) = sum x
value (Node x xs) = sum (map (ys!!) inds)
  where
    ys = map value xs
    len = length xs
    inds = mapMaybe (\i -> if i > 0 && i <= len then Just (i-1) else Nothing) x

main :: IO ()
main = input >>= print . value
