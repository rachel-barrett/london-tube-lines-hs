{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Routes.HttpApp
  ( httpApp, HttpApp ) where

import Routes.LineRoutes (lineRoutes, LineRoutes)
import Routes.StationRoutes (stationRoutes, StationRoutes)

import Servant
    ( Application, JSON, type (:>), type (:<|>)(..), Get, Server, type EmptyAPI(..), emptyServer)

type HttpApp = 
  EmptyAPI
    :<|> "lines" :> LineRoutes 
    :<|> "stations" :> StationRoutes 

httpApp :: Server HttpApp
httpApp = 
  emptyServer
    :<|> lineRoutes 
    :<|> stationRoutes