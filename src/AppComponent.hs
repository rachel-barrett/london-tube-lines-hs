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
import Database.SQLite.Simple ( close, open, Connection )

serverResource :: Resource Server
serverResource = do
  httpApp <- httpAppResource
  let port = configDefault.port
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

httpAppResource :: Resource Application
httpAppResource = do
  environmentHandle <- environmentHandleResource
  let httpApp = httpAppApply environmentHandle
  return httpApp

httpAppApply :: EnvironmentHandle -> Application
httpAppApply environmentHandle = 
  let
    lineStationDao = LineStationDao.apply environmentHandle.connection
    lineService = LineService.apply lineStationDao
    stationService = StationService.apply lineStationDao
    lineRoutes = LineRoutes.apply lineService
    stationRoutes = StationRoutes.apply stationService
    routes = Routes.apply lineRoutes stationRoutes
    swaggerRoutes = SwaggerRoutes.value
  in 
    serve (Proxy :: Proxy (SwaggerRoutes :<|> Routes)) (swaggerRoutes :<|> routes)

data EnvironmentHandle = EnvironmentHandle {
  connection :: Connection
}

environmentHandleResource :: Resource EnvironmentHandle
environmentHandleResource = environmentHandleResourceApply configDefault

environmentHandleResourceApply :: Config -> Resource EnvironmentHandle
environmentHandleResourceApply config =
  do
    connection <-  Resource.apply (ResourceConstructor 
      { acquire = open config.databaseUrl
      , release = close
      })
    return $ EnvironmentHandle {connection = connection}


data Config = Config 
  { port :: Int
  , databaseUrl :: String
  }

configDefault :: Config
configDefault = Config 
  { port = 8080
  , databaseUrl = "data/london-tube-lines.db"
  }