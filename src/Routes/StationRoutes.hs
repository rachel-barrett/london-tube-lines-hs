{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Routes.StationRoutes
  ( stationRoutes
  , StationRoutes
  ) where

import Services.StationService (stationService)
import Servant
    ( type (:<|>)(..), QueryParam, JSON, type (:>), Get, Server )
import Control.Monad.IO.Class (liftIO)

type StationRoutes =
  QueryParam "onLine" String :> Get '[JSON] [String] 

stationRoutes :: Server StationRoutes
stationRoutes = \onLineQueryParam ->
  liftIO $
    case onLineQueryParam of 
      Just onLine -> stationService.getStationsOnLine onLine
      Nothing -> stationService.getAllStations