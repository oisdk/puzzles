module Part1 where

import Input

main :: IO ()
main = input >>= print . sum . foldMap id
