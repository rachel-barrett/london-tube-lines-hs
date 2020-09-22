{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Routes.LineRoutes
  ( lineRoutes
  , LineRoutes
  ) where

import Services.LineService (lineService)
import Servant
    ( type (:<|>)(..), JSON, type (:>), Get, Server , QueryParam)
import Control.Monad.IO.Class (liftIO)

type LineRoutes = 
  QueryParam "passingThroughStation" String :> Get '[JSON] [String] 

lineRoutes :: Server LineRoutes
lineRoutes = \passingThroughStationQueryParam -> 
  liftIO $
    case passingThroughStationQueryParam of
      Just passingThroughStation -> lineService.getLinesPassingThroughStation passingThroughStation
      Nothing -> lineService.getAllLines