-- 7.6 Binary string transmitter
-- String -> Bit list
-- Bit list -> String
-- In this program, binary number is represented as reversed bit array
-- to make implementation easier (e.g. 13 -> 1011, not 1101)

module Transmit (encode, decode, transmit) where

-- ord :: Char -> Int (unicode code point)
-- chr :: Int -> Char
import Data.Char (ord, chr)

type Bit = Int

encode :: String -> [Bit]
encode = concat . map (make8 . int2bin . ord)

decode :: [Bit] -> String
decode = map (chr . bin2int) . chop8

-- Simulate transmission
transmit :: String -> String
transmit = decode . id . encode

bin2int :: [Bit] -> Int
bin2int = foldr (\x y -> x + 2 * y) 0
-- bin2int bits = sum [w * b | (w, b) <- zip weights bits]
--     where weights = iterate (*2) 1
-- (iterate f x = [x, f x, f (f x), f (f (f x)), ...])

int2bin :: Int -> [Bit]
int2bin 0 = []
int2bin n = (n `mod` 2) : int2bin (n `div` 2)

make8 :: [Bit] -> [Bit]
make8 bits = take 8 (bits ++ repeat 0)

chop8 :: [Bit] -> [[Bit]]
chop8 [] = []
chop8 bits = take 8 bits : chop8 (drop 8 bits)
