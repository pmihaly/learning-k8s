{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.String as BLU
import Data.Text
import Database.Redis
import EnvReading
import FactorialHandler
import EnvironmentHandler
import HelloHandler
import Logging
import RedisHandler
import Routing
import Web.Firefly

getRoutes :: Connection -> String -> Routes
getRoutes redisConnection environment =
  [ ("/", helloHandler),
    ("/factorial.*", factorialHandler),
    ("/redis.*", redisHandler redisConnection),
    ("/env.*", environmentHandler environment),
    ("/postgres", helloHandler)
  ]

neededEnvs :: [String]
neededEnvs = ["PORT", "REDIS_HOST", "REDIS_PORT", "ENVIRONMENT"]

main :: IO ()
main = do
  logMessage "Validating environment variables..."
  dieIfHasMissingEnv neededEnvs

  redisHost <- getEnvOrDie "REDIS_HOST"
  redisPort <- getEnvOrDie "REDIS_PORT"
  logMessage "Connecting to Redis..."
  redisConnection <- checkedConnect defaultConnectInfo {connectHost = redisHost, connectPort = PortNumber (read redisPort)}
  logMessage "Connected to Redis"

  environment <- getEnvOrDie "ENVIRONMENT"

  port <- getEnvOrDie "PORT"
  logMessage $ "Starting server on port " ++ port ++ "..."

  run (read port) $ logMessageMiddleware $ registerRoutes $ getRoutes redisConnection environment

  logMessage "Server has been shut down..."
