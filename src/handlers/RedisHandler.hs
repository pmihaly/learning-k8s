{-# LANGUAGE MultiWayIf #-}
{-# LANGUAGE OverloadedStrings #-}

module RedisHandler (redisHandler) where
import Database.Redis
import qualified Data.Text as T
import qualified Data.String as BLU
import Web.Firefly
import Control.Monad.Cont
import Data.Maybe

getAllKeys :: Connection -> IO [T.Text]
getAllKeys conn = do
  res <- runRedis conn $ keys "*"
  case res of
    Left _ -> return []
    Right keys -> return $ map (T.pack . show) keys

findKey :: Connection -> String -> IO T.Text
findKey conn keyToFind = do
  res <- runRedis conn $ Database.Redis.get $ BLU.fromString keyToFind
  case res of
    Left _ -> return ""
    Right keys -> return $ T.pack $ show $ fromJust keys

addKey :: Connection -> (String, String) -> IO T.Text
addKey conn keyValueToSet = do
  res <- runRedis conn $ set (BLU.fromString $ fst keyValueToSet) (BLU.fromString $ snd keyValueToSet)
  case res of
    Left _ -> return ""
    Right _ -> return $ T.pack $ show keyValueToSet

redisHandler :: Connection -> Handler T.Text
redisHandler redisConnection = do
  pathInfo <- getPathInfo
  method <- getMethod
  body <- getBody

  if
      | length pathInfo == 1 -> do
        allKeys <- liftIO $ getAllKeys redisConnection
        return $ BLU.fromString $ show allKeys
      | length pathInfo == 2 && method == "GET" -> liftIO $ findKey redisConnection $ T.unpack $ pathInfo !! 1
      | length pathInfo == 2 && method == "POST" -> liftIO $ addKey redisConnection (T.unpack $ pathInfo !! 1, T.unpack body)
      | otherwise -> return "Uh oh"
