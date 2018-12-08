module Main (main) where

import           Control.Applicative
import           Control.Monad.State
import           Data.Tree

parseTree :: [Int] -> Tree [Int]
parseTree = evalState go
  where
    pop = state (\(x:xs) -> (x, xs))
    go = do
        childNodes <- pop
        metaData <- pop
        liftA2 (flip Node) (replicateM childNodes go) (replicateM metaData pop)

value :: Tree [Int] -> Int
value (Node x []) = sum x
value (Node x xs) = sum [ ys !! (i-1) | i <- x, i > 0, i <= len ]
  where
    ys = map value xs
    len = length xs

main :: IO ()
main = do
    input <- parseTree . map read . words <$> readFile "../input"
    print (sum (foldMap id input))
    print (value input)
