module Blackjack
    ( Card(A, J, Q, K) -- Card(..)
    , cardForTestData
    , deck
    , heartSuit
    , diaSuit
    , cloverSuit
    , spadeSuit
    , sumHand
    ) where

import qualified Data.List.NonEmpty as NonEmpty
import Data.List.NonEmpty (NonEmpty((:|)))
import Data.Semigroup (sconcat)

data Card = A | N Int | J | Q | K deriving (Eq, Show)

sumHand :: [Card] -> Int
sumHand cards =
    let possiblePoints = map toPoint cards
        scoreCands = foldl plusEach (0 :| []) possiblePoints
        noBust = NonEmpty.filter (<= 21) scoreCands
    in
        if null noBust
            then NonEmpty.head scoreCands
            else maximum noBust

plusEach :: NonEmpty Int -> NonEmpty Int -> NonEmpty Int
plusEach xs = concatNonEmpty (\y -> NonEmpty.map (+ y) xs)

concatNonEmpty :: (a -> NonEmpty b) -> NonEmpty a -> NonEmpty b
concatNonEmpty f as = sconcat $ NonEmpty.map f as

toPoint :: Card -> NonEmpty Int
toPoint c = case c of
    N n -> n :| []
    A -> 1 :| [11]
    _ -> 10 :| []

suit, heartSuit, diaSuit, cloverSuit, spadeSuit :: [Card]
suit = [A] ++ map N [2..10] ++ [J, Q, K]
heartSuit = suit
diaSuit = suit
cloverSuit = suit
spadeSuit = suit

deck :: [Card]
deck = heartSuit ++ diaSuit ++ cloverSuit ++ spadeSuit

cardForTestData :: Int -> Card
cardForTestData = N
