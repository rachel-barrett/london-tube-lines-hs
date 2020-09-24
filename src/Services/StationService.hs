{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module Services.StationService
  ( StationService
  , apply
  ) where

import Daos.LineStationDao (LineStationDao)
import Data.Function ((&))
import Data.List (nub)

data StationService = StationService 
  { getAllStations :: IO [Station]
  , getStationsOnLine :: String -> IO [Station]
  }
type Station = String

apply :: LineStationDao -> StationService 
apply lineStationDao = StationService 
  
  { getAllStations = getAllStations
  , getStationsOnLine = getStationsOnLine
  }
    where
      
      getAllStations :: IO [Station]
      getAllStations = 
        lineStationDao.find 
          & fmap (\list -> 
              list 
                & map (.station)
                & nub
            )
      
      getStationsOnLine :: String -> IO [Station]
      getStationsOnLine line =
        lineStationDao.find
          & fmap ( \list -> 
              list 
                & filter ( \stationLine -> stationLine.line == line )
                & map (.station)
              )