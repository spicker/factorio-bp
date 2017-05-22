module Data.Icon exposing (..)

import Json.Decode exposing (..)


type Icon
    = Icon
        { type_ : String
        , name : String
        }


empty : Icon
empty =
    Icon { type_ = "", name = "" }


iconDecoder : Decoder Icon
iconDecoder =
    succeed empty
