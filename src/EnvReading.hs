module EnvReading (getEnvOrDie, dieIfHasMissingEnv) where

import Control.Monad
import Data.List
import Data.Maybe
import System.Environment
import System.Exit

getEnvOrDie :: String -> IO String
getEnvOrDie envToGet = do
  gotEnv <- lookupEnv envToGet
  case gotEnv of
    Nothing -> die $ "ERROR: " ++ envToGet ++ " environment variable not defined"
    Just env -> return env

dieIfHasMissingEnv :: [String] -> IO ()
dieIfHasMissingEnv envVarsToGet = do
  missingEnvVars <- flip filterM envVarsToGet $ \envVar -> do
    envVarExists <- lookupEnv envVar
    return $ isNothing envVarExists

  unless (null missingEnvVars) $ do
    die $ "ERROR: The following env vars are undefined: " ++ intercalate ", " missingEnvVars
