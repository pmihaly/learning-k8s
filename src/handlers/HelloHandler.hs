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

  return $ "Hello " <> fromMaybe "Stranger" name <> "!"
