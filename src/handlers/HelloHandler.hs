{-# LANGUAGE OverloadedStrings #-}

module HelloHandler (helloHandler) where

import Data.Maybe
import qualified Data.Text as T
import Text.Read
import Web.Firefly

-- | Get the 'name' query param from the url, if it doesn't exist use 'Stranger'
helloHandler :: Handler T.Text
helloHandler = do
  pathInfo <- getPathInfo
  name <- getQuery "name"

  case pathInfo of
    ["factorial", _] -> do
      case readMaybe $ T.unpack $ pathInfo !! 2 of
        Just n -> return $ T.pack $ show $ factorialOf n
        Nothing -> return "Invalid number"
      where
        factorialOf n = product [1 .. n]
    _ -> do
      return $ "Hello " <> fromMaybe "Stranger" name
