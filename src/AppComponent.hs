{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module AppComponent
  ( server ) where

import Data.Function ((&))
import Routes.HttpApp (httpApp, HttpApp)
import Network.Wai ( Application )
import Servant (Proxy(..), serve)
import Network.Wai.Handler.Warp ( run )

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
app = serve api httpApp

api :: Proxy HttpApp
api = Proxy