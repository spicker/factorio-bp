module Data.Signal exposing (..)

import Json.Decode exposing (..)


type alias Signal =
    { type_ : String
    , name : String
    }


empty : Signal
empty =
    { type_ = "", name = "" }


decoder : Decoder Signal
decoder =
    map2 Signal
        (field "type" string)
        (field "name" string)
