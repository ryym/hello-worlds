data Card = A | N Int | J | Q | K deriving (Eq, Show)

sumHand :: [Card] -> Int
sumHand [] = 0
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
