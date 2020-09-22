{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module Services.StationService
  ( stationService )
  where

type Station = String

data StationService = StationService {
  getAllStations :: IO [Station],
  getStationsOnLine :: String -> IO [Station]
}

stationService :: StationService 
stationService = StationService {
  getAllStations = return ["station1", "station2", "station3"],
  getStationsOnLine = \_ -> return ["station1"]
}