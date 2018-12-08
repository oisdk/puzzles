module Part1 where

import Data.Semigroup
import Data.Char
import FreeGroup

main :: IO ()
main = readFile "../input" >>= print . length . foldMap injectChar
