module Main where

readInt :: String -> Int
readInt ('+':xs) = read xs
readInt ('-':xs) = - read xs

main :: IO ()
main = do
  input <- readFile "../../input"
  print (sum (map readInt (lines input)))
