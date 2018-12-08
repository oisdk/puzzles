module Input where

import Data.Array
import Data.List (sort)

toLetter :: Int -> Char
toLetter = toEnum . (+) 65

fromLetter :: Char -> Int
fromLetter c = fromEnum c - 65

input :: IO (Array Int [Int])
input =
    fmap sort .
    accumArray (flip (:)) [] (0, 25) .
    map
        (\ln ->
              (fromLetter (ln !! 5), fromLetter (ln !! 36))) .
    lines <$>
    readFile "../input"
