{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module AppComponent
  ( server ) where

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

server :: Server
server = buildServer defaultConfig app

data Server = Server {runIndefinitely :: IO ()}

buildServer :: Config -> Application -> Server
buildServer config app = Server {
  runIndefinitely = do 
    putStrLn $ "server running at localhost:"++show (config.port)
    run (config.port) app
}

data Config = Config {
  port :: Int,
  databaseUrl :: String
}

defaultConfig = Config {port = 8080, databaseUrl = "replace_me"}

app :: Application
app = 
  let
    lineStationDao = Component.lineStationDao
    lineService = Component.lineService lineStationDao
    stationService = Component.stationService lineStationDao
    lineRoutes = Component.lineRoutes lineService
    stationRoutes = Component.stationRoutes stationService
    httpApp = Component.httpApp lineRoutes stationRoutes
  in serve api httpApp

api :: Proxy HttpApp
api = Proxy