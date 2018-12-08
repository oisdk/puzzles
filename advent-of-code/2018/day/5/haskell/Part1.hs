{-# LANGUAGE DeriveFoldable #-}

module Part1 where

import Data.Semigroup
import Data.Char

newtype FreeGroup a = FreeGroup
    { runFreeGroup :: [(Bool, a)]
    } deriving Foldable

instance Eq a => Semigroup (FreeGroup a) where
    xs <> FreeGroup [] = xs
    FreeGroup [] <> ys = ys
    FreeGroup (x':xs') <> FreeGroup (y@(yp,yv):ys) = FreeGroup (go xs' x')
      where
        go [] (xp,xv) | xp /= yp && xv == yv = ys
        go [] x = x : y : ys
        go (x2:xs) x1 = x1 : go xs x2

instance Eq a => Monoid (FreeGroup a) where
    mempty = FreeGroup []
    mappend = (<>)

injectChar :: Char -> FreeGroup Char
injectChar c
  | isAlpha c = FreeGroup [(isUpper c, toLower c)]
  | otherwise = mempty

main :: IO ()
main = readFile "../input" >>= print . length . foldMap injectChar
