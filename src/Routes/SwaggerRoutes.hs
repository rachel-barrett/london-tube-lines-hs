{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}

module Routes.SwaggerRoutes
  ( SwaggerRoutes
  , value
  ) where

import Servant ( JSON, QueryParam, type (:>), Get, Server, Proxy(..) )
import Data.Swagger
    ( Swagger,
      HasDescription(description),
      HasInfo(info),
      HasTitle(title),
      HasVersion(version) )
import Servant.Swagger ( HasSwagger(toSwagger) )
import Servant.Swagger.UI (SwaggerSchemaUI, swaggerSchemaUIServer)
import Routes.Routes (Routes)
import Data.Function ((&))
import Control.Lens ((.~), (?~) )

type SwaggerRoutes = SwaggerSchemaUI "swagger-ui" "swagger.json"

value :: Server SwaggerRoutes
value = swaggerSchemaUIServer swaggerJson

swaggerJson :: Swagger
swaggerJson = 
  toSwagger (Proxy :: Proxy Routes)
    & info.title .~ "London Tube Lines"
    & info.version .~ "1.0"
    & info.description ?~ "An Api to get info about London tube lines and stations"