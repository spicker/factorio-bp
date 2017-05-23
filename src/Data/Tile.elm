module Data.Tile exposing (..)

import Json.Decode exposing (Decoder, succeed, float, at, map2,field,string)


type alias Tile =
    { position : (Float, Float)
    , name : String}


empty : Tile 
empty = 
    Tile (0,0) ""


decoder : Decoder Tile
decoder =
    map2 Tile
        (map2 (,) (at ["position","x"] float) (at ["position","y"] float))
        (field "name" string)
