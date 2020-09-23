{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module Services.StationService
  ( stationService )
  where

import Daos.LineStationDao (lineStationDao)
import Data.Function ((&))

type Station = String

data StationService = StationService {
  getAllStations :: IO [Station],
  getStationsOnLine :: String -> IO [Station]
}

stationService :: StationService 
stationService = StationService {

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