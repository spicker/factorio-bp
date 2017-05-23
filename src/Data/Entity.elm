module Data.Entity exposing (..)

import Data.Entity.Connection as Connection exposing (Connection)
import Data.Entity.Module as Module exposing (Moduel)
import Data.Entity.ControlBehaviour as ConrolBehaviour exposing (ControlBehaivour)
import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Decode.Extra exposing (dict2, fromResult)
import Json.Decode.Pipeline exposing (decode, required, optional)


type alias Entity =
    { name : String
    , position : ( Float, Float )
    , direction : Direction
    , connections : List Connection
    , items : List Module
    }


type Direction
    = North
    | East
    | South
    | West


empty : Entity
empty =
    { name = "", position = ( 0, 0 ), direction = North, connections = [] }


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

        direction : Maybe Int -> Decoder Direction
        direction md =
            case md of
                Nothing ->
                    succeed North

                Just d ->
                    convert d
    in
        decode Entity
            |> required "name" string
            (map2 (,) (at [ "position", "x" ] float) (at [ "position", "y" ] float))
            ((maybe <| field "direction" int) |> andThen direction)
            (maybe <| list Connection.decoder)
