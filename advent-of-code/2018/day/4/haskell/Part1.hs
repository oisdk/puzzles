module Part1 where

import           Input

maximumOn :: Ord b => (a -> b) -> [a] -> Maybe a
maximumOn key xs = foldr f (fmap fst) xs Nothing
  where
    f x k Nothing = k (Just (x, key x))
    f x k ys@(Just (_, yk))
      | yk < xk = k (Just (x, xk))
      | otherwise = k ys
      where
        xk = key x


main :: IO ()
main = do
    Just (nm,sched) <-
        fmap (maximumOn (sum . map (uncurry (flip (-))) . snd)) input
    Just minute <-
        pure
            (maximumOn
                 (\minute ->
                       length
                           (filter
                                (\(start,end) ->
                                      start <= minute && minute < end)
                                sched))
                 [0 .. 59])
    print (nm * minute)
