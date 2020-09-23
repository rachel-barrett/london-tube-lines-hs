{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}
{-# LANGUAGE OverloadedStrings #-}

module Daos.LineStationDao 
  ( LineStationDao
  , lineStationDao
  ) where
  
import Data.Function ((&))
import Database.SQLite.Simple
    ( query_, field, FromRow(..), Connection )

data LineStation = LineStation {
  line :: String,
  station :: String
}

instance FromRow LineStation where
  fromRow = LineStation <$> field <*> field

data LineStationDao = LineStationDao {
  find :: IO [LineStation]
}

lineStationDao :: Connection -> LineStationDao
lineStationDao conn = LineStationDao {
  find = 
    query_ conn "select line, station from lineStation" 
}