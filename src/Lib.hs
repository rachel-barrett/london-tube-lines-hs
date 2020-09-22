module Lib
    ( main
    ) where

import AppComponent (app)
import Network.Wai.Handler.Warp ( run )

main :: IO ()
main = run 8080 app