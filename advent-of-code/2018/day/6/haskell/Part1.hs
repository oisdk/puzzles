module Part1 where

import           Input

import           Data.Foldable
import           Data.Maybe

import           Data.IntMap.Strict (IntMap)
import qualified Data.IntMap.Strict as IntMap
import           Data.IntSet        (IntSet)
import qualified Data.IntSet        as IntSet

import Data.List (sortOn)

minimumOn :: Ord b => (a -> b) -> [a] -> a
minimumOn key xs = fromJust $ foldr f (fmap fst) xs Nothing
  where
    f x k Nothing = k (Just (x, key x))
    f x k ys@(Just (_, yk))
      | xk < yk = k (Just (x, xk))
      | otherwise = k ys
      where
        xk = key x

distance :: (Int, Int) -> (Int, Int) -> Int
distance (x1,y1) (x2,y2) = abs (x1 - x2) + abs (y1 - y2)

minDist :: (Int, Int) -> [(Int, (Int, Int))] -> Maybe Int
minDist x xs = case sortOn snd ((fmap.fmap) (distance x) xs) of
  ((r,y) : (_,z) : _) | y /= z -> Just r
  _ -> Nothing

dists :: [(Int, (Int, Int))] -> [[Maybe Int]]
dists xs =
    [ [ minDist (x, y) xs
      | y <- [0 .. 400] ]
    | x <- [0 .. 400] ]

infs :: [(Int, (Int, Int))] -> IntSet
infs cs = foldMap (IntSet.fromList . mapMaybe (`minDist` cs)) [top, bot, lft, rgt]
  where
    xmin = -1000
    ymin = -1000
    xmax = 1000
    ymax = 1000
    top = [ (xmin, y) | y <- [ymin..ymax]]
    bot = [ (xmax, y) | y <- [ymin..ymax]]
    lft = [ (x, ymin) | x <- [xmin..xmax]]
    rgt = [ (x, ymax) | x <- [xmin..xmax]]


incr :: Int -> IntMap Int -> IntMap Int
incr = flip (IntMap.insertWith (+)) 1

sizes :: [(Int, (Int, Int))] -> IntMap Int
sizes xs =
    foldl' (flip incr) IntMap.empty (catMaybes =<< dists xs) `IntMap.withoutKeys` infs xs


main :: IO ()
main = do
    inp <- input
    print (infs (zip [1..] inp))
    print . maximum . sizes . zip [0..] =<< input
