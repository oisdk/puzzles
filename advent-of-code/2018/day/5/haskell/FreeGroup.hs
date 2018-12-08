{-# LANGUAGE DeriveFoldable #-}

module FreeGroup where

import Data.Semigroup
import Data.Char

newtype FreeGroup a = FreeGroup
    { runFreeGroup :: [(Bool, a)]
    } deriving Foldable

instance Eq a =>
         Semigroup (FreeGroup a) where
    FreeGroup [] <> ys = ys
    FreeGroup (x':xs') <> FreeGroup ys = FreeGroup (go xs' x')
      where
        go [] x@(xp,xv) = case ys of
          ((yp,yv):ys') | xp /= yp && xv == yv -> ys'
          _ -> x : ys
        go (x2:xs) x1 = x1 : go xs x2

instance Eq a => Monoid (FreeGroup a) where
    mempty = FreeGroup []
    mappend = (<>)

injectChar :: Char -> FreeGroup Char
injectChar c
  | isAlpha c = FreeGroup [(isUpper c, toLower c)]
  | otherwise = mempty
