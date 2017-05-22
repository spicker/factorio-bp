module Data.Entity exposing (..)

import Data.Entity.Connection exposing (Connection)
import Dict exposing (Dict)
import Json.Decode exposing (..)


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


empty : Entity
empty =
    Entity { name = "", position = ( 0, 0 ), direction = North, connections = Dict.empty }


entityDecoder : Decoder Entity
entityDecoder =
    succeed empty
