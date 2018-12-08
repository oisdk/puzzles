module Input where

import Control.Monad.State
import Data.Tree

pop :: State [a] a
pop = state (\(x:xs) -> (x, xs))

parseTree :: [Int] -> Tree [Int]
parseTree = evalState go
  where
    go = do
        childNodes <- pop
        metaData <- pop
        children <- replicateM childNodes go
        metaVals <- replicateM metaData pop
        pure (Node metaVals children)

input :: IO (Tree [Int])
input = parseTree . map read . words <$> readFile "../input"
