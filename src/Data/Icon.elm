module Data.Icon exposing (..)

import Json.Decode exposing (..)


type alias Icon =
    { type_ : String
    , name : String
    }


empty : Icon
empty =
    { type_ = "", name = "" }


decoder : Decoder Icon
decoder =
    map2 Icon
        (at [ "signal", "type" ] string)
        (at [ "signal", "name" ] string)
