module Logging (logMessage, logMessageMiddleware) where

import Control.Monad.Cont
import qualified Data.Text as T
import Data.Time
import qualified Network.Wai as W
import Web.Firefly

logMessage :: String -> IO ()
logMessage message = do
  timestamp <- getZonedTime
  putStrLn $ "[LOG] " ++ "[" ++ show timestamp ++ "] " ++ message

logMessageMiddleware :: App () -> App ()
logMessageMiddleware = addMiddleware before after
  where
    before = do
      path <- getPath
      method <- getMethod
      liftIO . logMessage $ T.unpack method ++ " " ++ T.unpack path
      waiRequest
    after resp = do
      liftIO $ logMessage $ show $ W.responseStatus resp
      return resp
