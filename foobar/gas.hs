import           Data.Bool
import           Control.Monad
import           Data.Foldable

uncurry3 f (x,y,z) = f x y z

showGas :: [[Bool]] -> String
showGas = unlines . (map.map) (bool '.' 'O')

fromString :: String -> [[Bool]]
fromString = (map.map) ('O'==)  . lines

slowBoard :: [[Bool]]
slowBoard = fromString $ unlines
  [ "O...O..."
  , "O..O...."
  , "...O...O"
  , "....OO.."
  ]

scanrM :: Monad m => (a -> b -> m b) -> b -> [a] -> m [b]
scanrM f b []     = pure [b]
scanrM f b (x:xs) = do
    bs <- scanrM f b xs
    b' <- f x (head bs)
    pure (b' : bs)

answer :: [[Bool]] -> Int
answer graph = length (flip (foldrM prev) graph =<< initial)
  where
    initial = replicateM (succ (length (head graph))) [False,True]
    prev xs below = flip (scanrM (uncurry3 f)) (zip3 xs below (tail below)) =<< [True, False]

    f True  False False p     = [ not p ]
    f False False False p     = [     p ]
    f True  True  True  _     = []
    f False True  True  _     = [ True, False ]
    f True  _     _     True  = []
    f False _     _     True  = [ True, False ]
    f c     _     _     False = [ not c ]

main :: IO ()
main = print . answer $ slowBoard

--  [ "O.O..OOO"
--  , "O.O...O."
--  , "OOO...O."
--  , "O.O...O."
--  , "O.O..OOO"
--  ]