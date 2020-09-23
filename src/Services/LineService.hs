{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module Services.LineService
  ( LineService
  , lineService 
  ) where

import Daos.LineStationDao (LineStationDao)
import Data.Function ((&))

type Line = String

data LineService = LineService {
  getAllLines :: IO [Line],
  getLinesPassingThroughStation :: String -> IO [Line]
}

lineService :: LineStationDao -> LineService
lineService lineStationDao = LineService {

  getAllLines = 
    lineStationDao.find 
      & fmap (\list -> list & map (.line)),

  getLinesPassingThroughStation = 
    \station ->
      lineStationDao.find
        & fmap (\list -> 
            list 
              & filter (\stationLine -> stationLine.station == station )
              & map (.line)
            )

}