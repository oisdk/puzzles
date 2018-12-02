module Main where

import           Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map

import Control.Arrow
import Data.Monoid

freqs :: Ord a => [a] -> Map a Int
freqs = map (flip (,) 1)
    >>> Map.fromListWith (+)

twosAndThrees :: Ord a => [a] -> (Bool, Bool)
twosAndThrees = freqs
            >>> foldMap ((2 ==) &&& (3 ==) >>> Any *** Any)
            >>> getAny *** getAny

checksum :: Ord a => [[a]] -> Int
checksum = map (twosAndThrees >>> fromEnum *** fromEnum)
       >>> foldMap (Sum *** Sum)
       >>> getSum *** getSum
       >>> uncurry (*)

main :: IO ()
main = readFile "../../input" >>= (lines >>> checksum >>> print)
