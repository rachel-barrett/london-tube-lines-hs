{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Routes.HttpApp
  ( httpApp, HttpApp ) where

import Routes.LineRoutes (LineRoutes)
import Routes.StationRoutes (StationRoutes)

import Servant
    ( Application, JSON, type (:>), type (:<|>)(..), Get, Server, type EmptyAPI(..), emptyServer)

type HttpApp = 
  EmptyAPI
    :<|> "lines" :> LineRoutes 
    :<|> "stations" :> StationRoutes 

httpApp :: Server LineRoutes -> Server StationRoutes -> Server HttpApp
httpApp lineRoutes stationRoutes = 
  emptyServer
    :<|> lineRoutes 
    :<|> stationRoutes