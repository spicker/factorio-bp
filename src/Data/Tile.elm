module Data.Tile exposing (..)

import Json.Decode exposing (Decoder, succeed)


type alias Tile =
    {}


decoder : Decoder Tile
decoder =
    succeed <| Tile
