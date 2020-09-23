{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module Services.StationService
  ( StationService
  , stationService 
  ) where

import Daos.LineStationDao (LineStationDao)
import Data.Function ((&))

type Station = String

data StationService = StationService {
  getAllStations :: IO [Station],
  getStationsOnLine :: String -> IO [Station]
}

stationService :: LineStationDao -> StationService 
stationService lineStationDao = StationService {

  getAllStations = 
    lineStationDao.find 
      & fmap (\list -> list & map (.station)),

  getStationsOnLine = 
    \line ->
      lineStationDao.find
        & fmap (\list -> 
            list 
              & filter (\stationLine -> stationLine.line == line )
              & map (.station)
            )

}