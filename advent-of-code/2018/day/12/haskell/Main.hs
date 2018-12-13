{-# LANGUAGE DataKinds              #-}
{-# LANGUAGE OverloadedStrings      #-}
{-# LANGUAGE TypeFamilies           #-}
{-# LANGUAGE TypeFamilyDependencies #-}
{-# LANGUAGE GADTs #-}
{-# OPTIONS_GHC -fno-warn-unticked-promoted-constructors #-}

module Main where

import Prelude hiding (lookup)
import           Control.Applicative
import           Data.Attoparsec.ByteString.Char8 hiding (take)
import qualified Data.ByteString                  as ByteString
import           Data.Kind
import Data.Foldable

data Env
  = Env Bool Bool Bool Bool Bool deriving Show

type Rule = (Env, Bool)

data N = Z | S N

type family RuleTree (n :: N) = (tr :: Type) | tr -> n where
    RuleTree Z = Bool
    RuleTree (S n) = RuleNode n

data RuleNode (n :: N) where
    (:*:) :: {-# UNPACK #-} !(RuleTree n) -> {-# UNPACK #-} !(RuleTree n) -> RuleNode n

class KnownRule (n :: N) where
    type Builder n :: Type
    type Curried n r :: Type
    build :: RuleTree n
    insert :: Builder n -> RuleTree n -> RuleTree n
    lookup :: RuleTree n -> Curried n Bool

instance KnownRule Z where
    type Builder Z = Bool
    type Curried Z r = r
    build = False
    {-# INLINE build #-}
    insert = const
    {-# INLINE insert #-}
    lookup = id
    {-# INLINE lookup #-}

instance KnownRule n => KnownRule (S n) where
    type Builder (S n) = (Bool, Builder n)
    type Curried (S n) r = Bool -> Curried n r
    build = build :*: build
    {-# INLINE build #-}
    insert (False , xs) (l :*: r) = insert xs l :*: r
    insert ( True , xs) (l :*: r) = l :*: insert xs r
    {-# INLINE insert #-}
    lookup (l :*: _) False = lookup l
    lookup (_ :*: r) True  = lookup r
    {-# INLINE lookup #-}

type Five = S (S (S (S (S Z))))

envRules :: [Rule] -> RuleTree Five
envRules = foldr f build
  where
    f (Env x1 x2 x3 x4 x5, y) = insert (x1, (x2, (x3, (x4, (x5, y)))))
    {-# INLINE f #-}
{-# INLINE envRules #-}

aliveState :: Parser Bool
aliveState = True <$ char '#' <|> False <$ char '.'

env :: Parser Env
env =
    Env <$> aliveState
        <*> aliveState
        <*> aliveState
        <*> aliveState
        <*> aliveState

rule :: Parser Rule
rule = liftA2 (,) env (string " => " *> aliveState)

state :: Parser [Bool]
state = string "initial state: " *> many aliveState

type Input = ([Bool], [Rule])

step :: RuleTree Five -> [Bool] -> [Bool]
step rules (x1 : x2 : x3 : x4 : xs)
    = lookup rules False False False False x1
    : lookup rules False False False x1 x2
    : lookup rules False False x1 x2 x3
    : lookup rules False x1 x2 x3 x4
    : go x1 x2 x3 x4 xs
  where
    go y1 y2 y3 y4 (y5 : ys) = lookup rules y1 y2 y3 y4 y5 : go y2 y3 y4 y5 ys
    go y1 y2 y3 y4 [] = lookup rules y1 y2 y3 y4 False
                      : lookup rules y2 y3 y4 False False
                      : lookup rules y3 y4 False False False
                      : lookup rules y4 False False False False
                      : []
step _ _ = undefined
{-# INLINE step #-}

answer :: Int -> [Bool] -> RuleTree Five -> Int
answer steps ste rules = sum (map snd (filter fst (zip res [back..])))
  where
    res = iterate (step rules) ste !! steps
    back = steps * (-2)
{-# INLINE answer #-}

input :: Parser Input
input = do
    initial <- state
    endOfLine
    endOfLine
    rules <- rule `sepBy` endOfLine
    endOfLine
    endOfInput
    return (initial, rules)

readInput :: IO Input
readInput =
    ByteString.readFile "../input" >>=
    either (ioError . userError) pure . parseOnly input

main :: IO ()
main = do
    (ste,rls) <- readInput
    let tree = envRules rls
    print (answer 20 ste tree)
    let steps = iterate (step tree) ste
    let chunks = take 100 (map head (iterate (drop 100) (zip [0..] steps)))
    for_ chunks $ \(i, xs) -> do
        print i
        print (sum (map snd (filter fst (zip xs [(i * (-2)) ..]) )))
