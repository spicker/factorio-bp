module Data.Entity.Module exposing (..)

import Json.Decode exposing (..)


type alias Module =
    { count : Int }


decoder : Decoder Module
decoder =
    map Module (field "count" int)
