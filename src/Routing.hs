module Routing (Routes, registerRoutes) where

import qualified Data.Text as T
import Web.Firefly
import Web.Firefly.Types

type Routes = [(Pattern, Handler T.Text)]

registerRoutes :: Routes -> App ()
registerRoutes = mapM_ (uncurry route)
