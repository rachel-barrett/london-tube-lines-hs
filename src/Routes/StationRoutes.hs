{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Routes.StationRoutes
  ( StationRoutes
  , apply
  ) where

import Services.StationService (StationService)
import Servant ( JSON, QueryParam, type (:>), Get, Server )
import Control.Monad.IO.Class (liftIO)

type StationRoutes =
  QueryParam "onLine" String :> Get '[JSON] [String] 

apply :: StationService -> Server StationRoutes
apply stationService = \onLineQueryParam ->
  liftIO $
    case onLineQueryParam of 
      Just onLine -> stationService.getStationsOnLine onLine
      Nothing -> stationService.getAllStations