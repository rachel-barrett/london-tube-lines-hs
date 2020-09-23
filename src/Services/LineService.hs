{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module Services.LineService
  ( LineService
  , apply 
  ) where

import Daos.LineStationDao (LineStationDao)
import Data.Function ((&))
import Data.List (nub)

data LineService = LineService 
  { getAllLines :: IO [Line]
  , getLinesPassingThroughStation :: String -> IO [Line]
  }
type Line = String

apply :: LineStationDao -> LineService
apply lineStationDao = LineService 
  {

    getAllLines = 
      lineStationDao.find 
        & fmap ( \list -> 
            list 
              & map (.line)
              & nub
          )

  , getLinesPassingThroughStation = \station ->
      lineStationDao.find
        & fmap ( \list -> 
            list 
              & filter ( \stationLine -> stationLine.station == station )
              & map (.line)
            )

  }