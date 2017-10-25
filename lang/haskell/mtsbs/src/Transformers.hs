module Transformers
    ( eval0
    , eval1
    , exampleExp
    ) where

import Control.Monad.Identity
import Control.Monad.Error -- Deprecated..!
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Writer
import Data.Maybe
import qualified Data.Map as Map

type Name   = String
data Exp    = Lit Integer
            | Var Name
            | Plus Exp Exp
            | Abs Name Exp -- Abstruct (lambda)
            | App Exp Exp -- Appy
            deriving (Show)

data Value  = IntVal Integer
            | FunVal Env Name Exp
            deriving (Show)

type Env    = Map.Map Name Value

eval0 :: Env -> Exp -> Value
eval0 env (Lit i) = IntVal i
eval0 env (Var n) = fromJust (Map.lookup n env)
eval0 env (Plus e1 e2) = let IntVal i1 = eval0 env e1
                             IntVal i2 = eval0 env e2
                        in   IntVal (i1 + i2)
eval0 env (Abs n e) = FunVal env n e
eval0 env (App e1 e2) = let val1 = eval0 env e1
                            val2 = eval0 env e2
                        in case val1 of
                            FunVal env' n body -> eval0 (Map.insert n val2 env') body

type Eval1 a = Identity a
runEval1 :: Eval1 a -> a
runEval1 ev = runIdentity ev

eval1 :: Env -> Exp -> Eval1 Value
eval1 env (Lit i) = return $ IntVal i

-- maybe (Eval1 b) -> (a -> Eval1 b) -> (Maybe a) -> b
-- maybe (fail b) -> return -> (lookup n env)
eval1 env (Var n) = maybe (fail ("undefined variable: " ++ n)) return $ Map.lookup n env

eval1 env (Plus e1 e2)  = do IntVal i1 <- eval1 env e1
                             IntVal i2 <- eval1 env e2
                             return $ IntVal (i1 + i2)
eval1 env (Abs n e)     = return $ FunVal env n e
eval1 env (App e1 e2)   = do val1 <- eval1 env e1
                             val2 <- eval1 env e2
                             case val1 of
                                FunVal env' n body ->
                                    eval1 (Map.insert n val2 env') body

exampleExp :: Exp
exampleExp = Lit 12 `Plus` (App (Abs "x" (Var "x")) (Lit 4 `Plus` Lit 2))
