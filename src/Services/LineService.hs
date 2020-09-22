{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module Services.LineService
  ( lineService )
  where

type Line = String

data LineService = LineService {
  getAllLines :: IO [Line],
  getLinesPassingThroughStation :: String -> IO [Line]
}

lineService :: LineService 
lineService = LineService {
  getAllLines = return ["line1", "line2", "line3"],
  getLinesPassingThroughStation = \_ -> return ["line1"]
}