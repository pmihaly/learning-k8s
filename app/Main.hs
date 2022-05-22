{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Text
import EnvReading
import HelloHandler
import Logging
import Routing
import Web.Firefly

routes :: Routes
routes =
  [ ("/", helloHandler),
    ("/postgres", helloHandler),
    ("/redis", helloHandler)
  ]

neededEnvs :: [String]
neededEnvs = ["PORT"]

main :: IO ()
main = do
  logMessage "Validating environment variables..."
  dieIfHasMissingEnv neededEnvs

  port <- getEnvOrDie "PORT"
  logMessage $ "Starting server on port " ++ port ++ "..."

  run (read port) $ logMessageMiddleware $ registerRoutes routes

  logMessage "Server has been shut down..."
