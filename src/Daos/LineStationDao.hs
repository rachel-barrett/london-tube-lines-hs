{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module Daos.LineStationDao 
  ( LineStationDao
  , lineStationDao
  ) where
  
import Data.Function ((&))

data LineStation = LineStation {
  line :: String,
  station :: String
}

data LineStationDao = LineStationDao {
  find :: IO [LineStation]
}

lineStationDao :: LineStationDao
lineStationDao = LineStationDao {
  find = return lineStations
}

lineStations :: [LineStation]
lineStations = 
  [ ("Central", "Notting Hill Gate")
  , ("Central", "Bond Street")
  , ("Jubilee", "Bond Street")
  , ("Jubilee", "Green Park")
  , ("Jubilee", "Westminster")
  , ("Jubilee", "London Bridge")
  , ("Northern", "London Bridge")
  , ("Northern", "King's Cross St Pancras")
  ] & map (\x -> case x of (,) a b -> LineStation a b)
