module Data.Entity exposing (..)

import Data.Entity.Connection exposing (Connection)
import Dict exposing (Dict)


type Entity
    = Entity
        { name : String
        , position : ( Float, Float )
        , direction : Direction
        , connections : Dict Int Connection
        }


type Direction
    = North
    | East
    | South
    | West
