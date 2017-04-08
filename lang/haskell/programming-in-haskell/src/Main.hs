module Main where

import Transmit (transmit)

main :: IO ()
main = do
  putStrLn $ transmit "higher-order functions are easy"
