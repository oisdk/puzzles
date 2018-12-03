module Main where

open import Data.Nat as ℕ using (ℕ; suc; zero)
open import Data.List as List using (List; _∷_; [])

ℕ-Set : Set
ℕ-Set = List ℕ

insert : ℕ → ℕ-Set → ℕ-Set
insert x [] = x ∷ []
insert x (y ∷ ys) with ℕ.compare x y
insert x (.(suc (x ℕ.+ k)) ∷ ys) | ℕ.less .x k = x ∷ k ∷ ys
insert x (.x ∷ ys) | ℕ.equal .x = x ∷ ys
insert .(suc (y ℕ.+ k)) (y ∷ ys) | ℕ.greater .y k = y ∷ insert k ys

open import Data.Bool

member : ℕ → ℕ-Set → Bool
member x [] = false
member x (y ∷ ys) with ℕ.compare x y
member x (.(suc (x ℕ.+ k)) ∷ ys) | ℕ.less .x k = false
member x (.x ∷ ys) | ℕ.equal .x = true
member .(suc (y ℕ.+ k)) (y ∷ ys) | ℕ.greater .y k = member k ys

fromList : List ℕ → ℕ-Set
fromList = List.foldr insert []

example : ℕ-Set
example = fromList (4 ∷ 1 ∷ 0 ∷ 6 ∷ 10 ∷ [])
