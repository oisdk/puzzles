{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE BangPatterns #-}

module Part2 where

import           Input

import           Data.Array
import qualified Data.IntMap as IntMap
import qualified Data.IntSet as IntSet

type Job a = (Int, a)
type Queue a = [Job a]

addJob :: Ord a => Job a -> Queue a -> Queue a
addJob (i,x) ((j,y):ys)
  | i > j = (j, y) : addJob (i - j, x) ys
  | otherwise = (i, x) : (j - i, y) : ys
addJob x [] = [x]

data N = Z | S N

topSort :: Array Int [Int] -> Int
topSort graph = go 0 init' [] (S (S (S (S (S Z))))) orig
  where
    orig = IntMap.fromListWith (+) $ foldMap (map (flip (,) 1)) graph
    init' = IntSet.fromList (indices graph) IntSet.\\ IntMap.keysSet orig

    go !i (IntSet.minView -> Just (j,js)) working (S workers) indegs =
      go i js (addJob (j+61, j) working) workers indegs
    go !i jobs ((wt,w): ws) workers indegs = case foldr upd (jobs, indegs) (graph ! w) of
      (jobs', indegs') -> go (i + wt) jobs' ws (S workers) indegs'
    go !i _ [] _ _ = i

    upd y (av,indegs) =
        case IntMap.updateLookupWithKey (const (\i -> if i == 1 then Nothing else Just (i - 1 :: Int))) y indegs of
            (Just 1,indegs') -> (IntSet.insert y av, indegs')
            (_,indegs')      -> (av, indegs')

main :: IO ()
main = print . topSort =<< input
