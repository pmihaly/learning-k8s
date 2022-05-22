{-# LANGUAGE OverloadedStrings #-}

module FactorialHandler (factorialHandler) where

import Data.Maybe
import qualified Data.Text as T
import Text.Read
import Web.Firefly

factorialHandler :: Handler T.Text
factorialHandler = do
  pathInfo <- getPathInfo

  case pathInfo of
    ["factorial", _] -> do
      case readMaybe $ T.unpack $ pathInfo !! 1 of
        Just n -> return $ T.pack $ show $ factorialOf n
        Nothing -> return "Invalid number"
      where
        factorialOf n = product [1 .. n]
    _ -> do
      return "No number given"
