module Part2 where

import Data.Maybe
import Input

maximumOn :: Ord b => (a -> b) -> [a] -> a
maximumOn key xs = fromJust $ foldr f (fmap fst) xs Nothing
  where
    f x k Nothing = k (Just (x, key x))
    f x k ys@(Just (_, yk))
      | yk < xk = k (Just (x, xk))
      | otherwise = k ys
      where
        xk = key x

main :: IO ()
main = do
    freqSleeps <-
        (fmap . fmap . fmap)
            (\schedule ->
                  maximumOn
                      snd
                      [ ( minute
                        , length
                              [ ()
                              | (start,end) <- schedule
                              , start <= minute
                              , minute < end ])
                      | minute <- [0 .. 59] ])
        input
    let (mostAsleepId,(mostAsleepMinute,_)) = maximumOn (snd . snd) freqSleeps
    print (mostAsleepId * mostAsleepMinute)
