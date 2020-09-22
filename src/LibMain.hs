{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module LibMain
    ( main
    ) where

import Data.Function ((&))
import AppComponent (server)

main :: IO ()
main = server.runIndefinitely