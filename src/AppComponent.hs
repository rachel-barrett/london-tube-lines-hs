{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module AppComponent
  ( serverResource ) where

import Data.Function ((&))
import Network.Wai ( Application )
import Servant (Proxy(..), serve)
import Network.Wai.Handler.Warp ( run )
import Routes.HttpApp (HttpApp)

import qualified Daos.LineStationDao as Component (lineStationDao)
import qualified Services.LineService as Component (lineService)
import qualified Services.StationService as Component (stationService)
import qualified Routes.LineRoutes as Component (lineRoutes)
import qualified Routes.StationRoutes as Component (stationRoutes)
import qualified Routes.HttpApp as Component (httpApp)

import Util.Resource as Resource
import Database.SQLite.Simple

serverResource :: Resource Server
serverResource = do
  httpApp <- httpAppResource
  let port = defaultConfig.port
  let server = buildServer port httpApp
  return server

data Server = Server {runIndefinitely :: IO ()}

buildServer :: Port -> Application -> Server
buildServer port app = Server {
  runIndefinitely = do 
    putStrLn $ "server running at localhost:"++show (port)
    run port app
}

type Port = Int

httpAppResource :: Resource Application
httpAppResource = do
  environmentHandle <- buildEnvironmentHandle defaultConfig
  let httpApp = buildApp environmentHandle
  return httpApp

buildApp :: EnvironmentHandle -> Application
buildApp environmentHandle = let
    lineStationDao = Component.lineStationDao environmentHandle.connection
    lineService = Component.lineService lineStationDao
    stationService = Component.stationService lineStationDao
    lineRoutes = Component.lineRoutes lineService
    stationRoutes = Component.stationRoutes stationService
    httpApp = Component.httpApp lineRoutes stationRoutes
  in serve api httpApp

api :: Proxy HttpApp
api = Proxy

data EnvironmentHandle = EnvironmentHandle {
  connection :: Connection
}

buildEnvironmentHandle :: Config -> Resource EnvironmentHandle
buildEnvironmentHandle config = 
  Resource.apply (ResourceConstructor 
    { acquire = open config.databaseUrl
    , release = close
    }
  ) & fmap (EnvironmentHandle)

data Config = Config 
  { port :: Int
  , databaseUrl :: String
  }

defaultConfig :: Config
defaultConfig = Config 
  { port = 8080
  , databaseUrl = "data/london-tube-lines.db"
  }