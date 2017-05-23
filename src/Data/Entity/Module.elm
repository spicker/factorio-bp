module Data.Entity.Module exposing (..)

import Json.Decode exposing (..)


type alias Module =
    { name : String, count : Int }


decode : Decoder Module
decode =
    succeed <| Module "" 0
