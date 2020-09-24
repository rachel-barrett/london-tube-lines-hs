{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}

module AppComponent
  ( serverResource ) where

import Data.Function ((&))
import Network.Wai (Application)
import Servant (Proxy(..), serve, type (:<|>)(..))
import Network.Wai.Handler.Warp (run)

import qualified Daos.LineStationDao as LineStationDao
import qualified Services.LineService as LineService
import qualified Services.StationService as StationService
import qualified Routes.LineRoutes as LineRoutes
import qualified Routes.StationRoutes as StationRoutes
import qualified Routes.Routes as Routes
import Routes.Routes (Routes)
import qualified Routes.SwaggerRoutes as SwaggerRoutes
import Routes.SwaggerRoutes (SwaggerRoutes)

import Util.Resource as Resource
    ( ResourceConstructor(..),
      Resource,
      apply )
import qualified Database.SQLite.Simple as Database

serverResource :: Resource Server
serverResource = do
  let config = configDefault
  environmentHandle <- environmentHandleResourceApply config
  let httpApp = httpAppApply environmentHandle
  let port = config.port
  let server = serverApply port httpApp
  return server


data Server = Server {runIndefinitely :: IO ()}

serverApply :: Port -> Application -> Server
serverApply port app = Server {
  runIndefinitely = do 
    putStrLn $ "starting server at localhost:"++show (port)
    run port app
}
type Port = Int


httpAppApply :: EnvironmentHandle -> Application
httpAppApply environmentHandle = 
  let
    lineStationDao = LineStationDao.apply environmentHandle.databaseConnection
    lineService = LineService.apply lineStationDao
    stationService = StationService.apply lineStationDao
    lineRoutes = LineRoutes.apply lineService
    stationRoutes = StationRoutes.apply stationService
    routes = Routes.apply lineRoutes stationRoutes
    swaggerRoutes = SwaggerRoutes.value
  in 
    serve (Proxy :: Proxy (SwaggerRoutes :<|> Routes)) (swaggerRoutes :<|> routes)


data EnvironmentHandle = EnvironmentHandle {
  databaseConnection :: Database.Connection
}

environmentHandleResourceApply :: Config -> Resource EnvironmentHandle
environmentHandleResourceApply config =
  do
    databaseConnection <-  Resource.apply (ResourceConstructor 
      { acquire = Database.open config.databasePath
      , release = Database.close
      })
    return $ EnvironmentHandle {databaseConnection = databaseConnection}


data Config = Config 
  { port :: Int
  , databasePath :: String
  }

configDefault :: Config
configDefault = Config 
  { port = 8080
  , databasePath = "data/london-tube-lines.db"
  }