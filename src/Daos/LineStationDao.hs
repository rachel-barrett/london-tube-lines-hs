{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}
{-# LANGUAGE OverloadedStrings #-}

module Daos.LineStationDao 
  ( LineStationDao
  , apply
  ) where

import Database.SQLite.Simple
    ( query_, field, FromRow(..), Connection )

data LineStationDao = LineStationDao {
  find :: IO [LineStation]
}

data LineStation = LineStation {
  line :: String,
  station :: String
}

apply :: Connection -> LineStationDao
apply conn = LineStationDao {
  find = 
    query_ conn "select line, station from lineStation" 
}

instance FromRow LineStation where
  fromRow = LineStation <$> field <*> field