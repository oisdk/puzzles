{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE OverloadedStrings #-}

module Input (input) where

import           Data.Attoparsec.ByteString.Char8
import           Data.ByteString                  as ByteString

coord :: Parser (Int, Int)
coord = do
    x <- decimal
    _ <- ", "
    y <- decimal
    pure (x, y)

input :: IO [(Int, Int)]
input =
    ByteString.readFile "../input" >>=
    either (ioError . userError) pure .
    parseOnly (sepBy coord endOfLine <* endOfInput)
