module Part2 where

import FreeGroup

removeEl :: Eq a => a -> FreeGroup a -> FreeGroup a
removeEl x (FreeGroup xs) = foldMap f xs
  where
    f (p, y) | x == y = mempty
             | otherwise = FreeGroup [(p,y)]

removed :: FreeGroup Char -> [Int]
removed xs = [ length (removeEl c xs) | c <- ['a'..'z']]

main :: IO ()
main = readFile "../input" >>= print .  minimum . removed . foldMap injectChar
