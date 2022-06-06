module EnvironmentHandler (environmentHandler) where

import Data.Maybe
import qualified Data.Text as T
import Text.Read
import Web.Firefly

environmentHandler :: String -> Handler T.Text
environmentHandler environment = do
  return $ T.pack environment
