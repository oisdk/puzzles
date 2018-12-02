module Main where

import Control.Applicative
import Data.Maybe

inCommon :: Eq a => [a] -> [a] -> Maybe [a]
inCommon (x:xs) (y:ys)
  | x == y = fmap (x :) (inCommon xs ys)
  | xs == ys = Just xs
inCommon _ _ = Nothing

allPairs :: Eq a => [[a]] -> [a]
allPairs xs = head (catMaybes (liftA2 inCommon xs xs))

main :: IO ()
main = readFile "../../input" >>= putStrLn . allPairs . lines
