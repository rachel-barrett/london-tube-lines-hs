{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Routes.LineRoutes
  ( LineRoutes
  , apply
  ) where

import Services.LineService (LineService)
import Servant ( JSON, QueryParam, type (:>), Get, Server )
import Control.Monad.IO.Class (liftIO)

type LineRoutes = 
  QueryParam "passingThroughStation" String :> Get '[JSON] [String] 

apply :: LineService -> Server LineRoutes
apply lineService = \passingThroughStationQueryParam -> 
  liftIO $
    case passingThroughStationQueryParam of
      Just passingThroughStation -> lineService.getLinesPassingThroughStation passingThroughStation
      Nothing -> lineService.getAllLines