module Main where

import qualified Data.IntSet   as IntSet

readInt :: String -> Int
readInt ('+':xs) = read xs
readInt ('-':xs) = - read xs
readInt xs = error ("no parse: " ++ xs)

firstRepeat :: [Int] -> Int
firstRepeat xs = foldr f undefined xs IntSet.empty
  where
    f i k ys
      | IntSet.member i ys = i
      | otherwise = k (IntSet.insert i ys)

firstFreqRepeat :: [Int] -> Int
firstFreqRepeat = firstRepeat . scanl (+) 0 . cycle

main :: IO ()
main = print . firstFreqRepeat . map readInt . lines =<< readFile "../../input"
