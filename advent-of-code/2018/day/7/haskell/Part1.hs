module Part1 where

import           Input

import           Data.Array
import qualified Data.IntMap as IntMap
import qualified Data.IntSet as IntSet
import           Data.List

topSort :: Array Int [Int] -> [Int]
topSort graph = unfoldr (uncurry go) (init', orig)
  where
    orig = IntMap.fromListWith (+) $ foldMap (map (flip (,) 1)) graph
    init' = IntSet.fromList (indices graph) IntSet.\\ IntMap.keysSet orig
    go available indegs = do
        (x,xs) <- IntSet.minView available
        pure (x, foldr upd (xs, indegs) (graph ! x))
    upd y (av,indegs) =
        case IntMap.updateLookupWithKey
                 (const
                      (\i ->
                            if i == 1
                                then Nothing
                                else Just (i - 1 :: Int)))
                 y
                 indegs of
            (Just 1,indegs') -> (IntSet.insert y av, indegs')
            (_,indegs') -> (av, indegs')

main :: IO ()
main = print . map toLetter . topSort =<< input
