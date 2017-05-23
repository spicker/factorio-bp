module Data.Entity.Module exposing (..)

import Json.Decode exposing (..)


type alias Module =
    { name : String, count : Int }


decoder : Decoder Module
decoder =
    succeed <| Module "" 0
