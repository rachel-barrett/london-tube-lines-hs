{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Routes.HttpApp
  ( httpApp, HttpApp ) where

import Routes.LineRoutes (lineRoutes, LineRoutes)
import Routes.StationRoutes (stationRoutes, StationRoutes)

import Data.Aeson ()
import Data.Aeson.TH (deriveJSON, defaultOptions)
import Servant
    ( Application, JSON, type (:>), type (:<|>)(..), Get, Server, type EmptyAPI(..), EmptyServer)

type HttpApp = 
  "lines" :> LineRoutes 
    :<|> "stations" :> StationRoutes 

httpApp :: Server HttpApp
httpApp = 
  lineRoutes 
    :<|> stationRoutes