module Transformers
    ( eval0
    , eval1
    , exampleExp
    ) where

import Control.Monad.Identity
import Control.Monad.Except
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

-- Identity モナドで包む
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

-- ExceptT で包む
type Eval2 a = ExceptT String Identity a
runEval2 :: Eval2 a -> Either String a
runEval2 ev = runIdentity (runExceptT ev)

eval2a :: Env -> Exp -> Eval2 Value
eval2a env (Lit i)      = return $ IntVal i
eval2a env (Var n)      = maybe (fail ("undefined variable: " ++ n)) return $ Map.lookup n env
eval2a env (Plus e1 e2) = do IntVal i1 <- eval2a env e1
                             IntVal i2 <- eval2a env e2
                             return $ IntVal (i1 + i2)
eval2a env (Abs n e)    = return $ FunVal env n e
eval2a env (App e1 e2)  = do val1 <- eval2a env e1
                             val2 <- eval2a env e2
                             case val1 of
                                FunVal env' n body
                                    -> eval2a (Map.insert n val2 env') body

-- エラーの場合は例外ではなく Left を返すようにする
eval2b :: Env -> Exp -> Eval2 Value
eval2b env (Lit i)      = return $ IntVal i
eval2b env (Var n)      = maybe (fail ("undefined variable: " ++ n)) return $ Map.lookup n env
eval2b env (Plus e1 e2) = do e1' <- eval2b env e1
                             e2' <- eval2b env e2
                             case (e1', e2') of
                                (IntVal i1, IntVal i2)
                                    -> return $ IntVal (i1 + i2)
                                _   -> throwError "type error"
eval2b env (Abs n e)    = return $ FunVal env n e
eval2b env (App e1 e2)  = do val1 <- eval2b env e1
                             val2 <- eval2b env e2
                             case val1 of
                                FunVal env' n body
                                    -> eval2b (Map.insert n val2 env') body
                                _   -> throwError "type error"

-- 最終型 (Map.lookup での失敗もハンドルする)
eval2 :: Env -> Exp -> Eval2 Value
eval2 env (Lit i)      = return $ IntVal i
eval2 env (Var n)      = case Map.lookup n env of
                            Nothing -> fail ("undefined variable: " ++ n)
                            Just val -> return val
eval2 env (Plus e1 e2) = do e1' <- eval2 env e1
                            e2' <- eval2 env e2
                            case (e1', e2') of
                                (IntVal i1, IntVal i2)
                                    -> return $ IntVal (i1 + i2)
                                _   -> throwError "type error"
eval2 env (Abs n e)    = return $ FunVal env n e
eval2 env (App e1 e2)  = do val1 <- eval2 env e1
                            val2 <- eval2 env e2
                            case val1 of
                                FunVal env' n body
                                    -> eval2 (Map.insert n val2 env') body
                                _   -> throwError "type error"

-- https://wiki.haskell.org/All_About_Monads

type Eval3 a = ReaderT Env (ExceptT String Identity) a
runEval3 :: Env -> Eval3 a -> Either String a
runEval3 env ev = runIdentity $ runExceptT $ runReaderT ev env

-- Readerモナドを使う事で、必要な場合にだけ env にアクセスする形にできる。
eval3 :: Exp -> Eval3 Value
eval3 (Lit i) = return $ IntVal i
eval3 (Var n) = do env <- ask
                   case Map.lookup n env of
                       Nothing -> fail ("undefined variable: " ++ n)
                       Just val -> return val
eval3 (Plus e1 e2) = do e1' <- eval3 e1
                        e2' <- eval3 e2
                        case (e1', e2') of
                            (IntVal i1, IntVal i2)
                                -> return $ IntVal (i1 + i2)
                            _   -> throwError "type error in addition"
eval3 (Abs n e) = do env <- ask
                     return $ FunVal env n e
eval3 (App e1 e2) = do val1 <- eval3 e1
                       val2 <- eval3 e2
                       case val1 of
                            FunVal env' n body
                                -> local (const (Map.insert n val2 env')) (eval3 body)
                            _   -> throwError "type error in application"

-- Stateモナドで計算中の状態を保持する
type Eval4 a = ReaderT Env (ExceptT String (StateT Integer Identity)) a
runEval4 :: Env -> Integer -> Eval4 a -> (Either String a, Integer)
runEval4 env st ev = runIdentity $ runStateT (runExceptT $ runReaderT ev env) st
-- (ExceptT と StateT の包含関係が逆だと、戻り値は`Either (String (a, Integer))`になる)

tick :: (Num s, MonadState s m) => m ()
tick = do
    st <- get
    put (st + 1)

eval4 :: Exp -> Eval4 Value
eval4 (Lit i) = do
    tick
    return $ IntVal i
eval4 (Var n) = do
    tick
    env <- ask
    case Map.lookup n env of
        Nothing -> fail ("undefined variable: " ++ n)
        Just val -> return val
eval4 (Plus e1 e2) = do
    tick
    e1' <- eval4 e1
    e2' <- eval4 e2
    case (e1', e2') of
        (IntVal i1, IntVal i2)
            -> return $ IntVal (i1 + i2)
        _   -> throwError "type error in addition"
eval4 (Abs n e) = do
    tick
    env <- ask
    return $ FunVal env n e
eval4 (App e1 e2) = do
    tick
    val1 <- eval4 e1
    val2 <- eval4 e2
    case val1 of
        FunVal env' n body
            -> local (const (Map.insert n val2 env')) (eval4 body)
        _   -> throwError "type error in application"

-- Writerモナドでログを出力する
type Eval5 a = ReaderT Env (
    ExceptT String
    (WriterT [String] (StateT Integer Identity))
    ) a
runEval5 :: Env -> Integer -> Eval5 a -> ((Either String a, [String]), Integer)
runEval5 env st ev =
    runIdentity $ runStateT (runWriterT $ runExceptT $ runReaderT ev env) st

eval5 :: Exp -> Eval5 Value
eval5 (Lit i) = do
    tick
    return $ IntVal i
eval5 (Var n) = do
    tick
    tell [n]
    env <- ask
    case Map.lookup n env of
        Nothing -> fail ("undefined variable: " ++ n)
        Just val -> return val
eval5 (Plus e1 e2) = do
    tick
    e1' <- eval5 e1
    e2' <- eval5 e2
    case (e1', e2') of
        (IntVal i1, IntVal i2)
            -> return $ IntVal (i1 + i2)
        _   -> throwError "type error in addition"
eval5 (Abs n e) = do
    tick
    env <- ask
    return $ FunVal env n e
eval5 (App e1 e2) = do
    tick
    val1 <- eval5 e1
    val2 <- eval5 e2
    case val1 of
        FunVal env' n body
            -> local (const (Map.insert n val2 env')) (eval5 body)
        _   -> throwError "type error in application"

-- IO が必要な場合は内側のIdentityをIOにしちゃう
type Eval6 a = ReaderT Env (
    ExceptT String
    (WriterT [String] (StateT Integer IO))
    ) a
runEval6 :: Env -> Integer -> Eval6 a -> IO ((Either String a, [String]), Integer)
runEval6 env st ev =
    runStateT (runWriterT $ runExceptT $ runReaderT ev env) st

eval6 :: Exp -> Eval6 Value
eval6 (Lit i) = do
    tick
    liftIO $ print i
    return $ IntVal i
eval6 (Var n) = do
    tick
    tell [n]
    env <- ask
    case Map.lookup n env of
        Nothing -> fail ("undefined variable: " ++ n)
        Just val -> return val
eval6 (Plus e1 e2) = do
    tick
    e1' <- eval6 e1
    e2' <- eval6 e2
    case (e1', e2') of
        (IntVal i1, IntVal i2)
            -> return $ IntVal (i1 + i2)
        _   -> throwError "type error in addition"
eval6 (Abs n e) = do
    tick
    env <- ask
    return $ FunVal env n e
eval6 (App e1 e2) = do
    tick
    val1 <- eval6 e1
    val2 <- eval6 e2
    case val1 of
        FunVal env' n body
            -> local (const (Map.insert n val2 env')) (eval6 body)
        _   -> throwError "type error in application"
