{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Routes.Routes
  ( Routes
  , apply 
  ) where

import Routes.LineRoutes (LineRoutes)
import Routes.StationRoutes (StationRoutes)

import Servant
    ( emptyServer, type (:<|>)(..), EmptyAPI, type (:>), Server )

type Routes = 
  EmptyAPI
    :<|> "lines" :> LineRoutes 
    :<|> "stations" :> StationRoutes 

apply :: Server LineRoutes -> Server StationRoutes -> Server Routes
apply lineRoutes stationRoutes = 
  emptyServer
    :<|> lineRoutes 
    :<|> stationRoutes