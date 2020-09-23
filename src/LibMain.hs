{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module LibMain
  ( main
  ) where

import AppComponent (serverResource)
import Util.Resource ( Resource(use) )

main :: IO ()
main = 
  use serverResource (\server -> 
    server.runIndefinitely
  )