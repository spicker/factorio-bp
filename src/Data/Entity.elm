module Data.Entity exposing (..)

import Data.Entity.Connection as Connection exposing (Connection)
import Data.Entity.Module as Module exposing (Module)
import Data.Entity.ControlBehaviour as ConrolBehaviour exposing (ControlBehaviour)
import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Decode.Extra exposing (dict2, fromResult)
import Json.Decode.Pipeline exposing (decode, required, optional, requiredAt, custom, hardcoded)


type alias Entity =
    { name : String
    , position : ( Float, Float )
    , direction : Direction
    , connections : List Connection
    , modules : List Module
    }


type Direction
    = North
    | East
    | South
    | West


empty : Entity
empty =
    { name = "", position = ( 0, 0 ), direction = North, connections = [], modules = [] }


decoder : Decoder Entity
decoder =
    let
        convert : Int -> Decoder Direction
        convert d =
            case d of
                0 ->
                    succeed North

                2 ->
                    succeed West

                4 ->
                    succeed South

                6 ->
                    succeed East

                _ ->
                    fail "Invalid value for Direction"

        direction : Decoder Direction
        direction =
            int |> andThen convert

        position : Decoder ( Float, Float )
        position =
            decode (,)
                |> requiredAt [ "position", "x" ] float
                |> requiredAt [ "position", "y" ] float
    in
        decode Entity
            |> required "name" string
            |> custom (map2 (,) (at [ "position", "x" ] float) (at [ "position", "y" ] float))
            |> optional "direction" direction North
            -- |> optional "connections" (list Connection.decoder) []
            |>
                hardcoded []
            |> optional "items" (list Module.decoder) []
