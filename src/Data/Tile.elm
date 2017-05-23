module Data.Tile exposing (..)

import Json.Decode exposing (Decoder, succeed, map, field, string)


type alias Tile =
    { name : String
    }


empty : Tile
empty =
    Tile ""


decoder : Decoder Tile
decoder =
    map Tile
        (field "name" string)
