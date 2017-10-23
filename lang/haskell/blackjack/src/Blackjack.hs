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

data Card = A | N Int | J | Q | K deriving (Eq, Show)

sumHand :: [Card] -> Int
sumHand cards =
    let possiblePoints = map toPoint cards
        scoreCands = foldl plusEach [0] possiblePoints
        noBust = filter (<= 21) scoreCands
    in
        if null noBust
            then head scoreCands
            else maximum noBust --foldl max 0 noBust

plusEach :: [Int] -> [Int] -> [Int]
plusEach xs = concatMap (\y -> map (+ y) xs)

toPoint :: Card -> [Int]
toPoint c = case c of
    N n -> [n]
    A -> [1, 11]
    _ -> [10]

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
