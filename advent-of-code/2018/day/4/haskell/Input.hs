{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Input (input) where

import           Control.Applicative
import           Control.Arrow                    (first)
import           Data.Attoparsec.ByteString.Char8
import qualified Data.ByteString                  as ByteString
import           Data.List                        (sortOn)
import qualified Data.IntMap.Strict as IntMap

data Event
    = Start Int
    | Sleep
    | Wake
    deriving Show

data Date = Date
    { year   :: Int
    , month  :: Int
    , day    :: Int
    , hour   :: Int
    , minute :: Int
    } deriving (Eq,Ord,Show)

date :: Parser Date
date = do
    year <- decimal
    _ <- "-"
    month <- decimal
    _ <- "-"
    day <- decimal
    _ <- " "
    hour <- decimal
    _ <- ":"
    minute <- decimal
    pure Date {..}

event :: Parser Event
event = Wake  <$  "wakes up"
    <|> Sleep <$  "falls asleep"
    <|> Start <$> ("Guard #" *> decimal <* " begins shift")

line :: Parser (Date, Event)
line = liftA2 (,) ("[" *> date) ("] " *> event)

events :: Parser [(Date, Event)]
events = sepBy line endOfLine

input :: IO [(Int,[(Int, Int)])]
input =
    collateEvents . sortOn fst <$>
    (ByteString.readFile "../input" >>=
     either (ioError . userError) pure . parseOnly (events <* endOfInput))

collateEvents :: [(Date, Event)] -> [(Int, [(Int, Int)])]
collateEvents ((_, Start nm') : xs') = IntMap.toList . IntMap.fromListWith (++) $ uncurry (:) (go nm' xs')
  where
    go nm ((y,Sleep):(z,Wake):xs) = (first.fmap) ((minute y, minute z):) (go nm xs)
    go nm ((_, Start nm'') : xs)  = ((nm, []) , uncurry (:) (go nm'' xs))
    go nm [] = ((nm , []) , [])
    go _ _ = undefined
collateEvents _ = undefined
