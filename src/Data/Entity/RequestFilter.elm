module Data.Entity.RequestFilter exposing (..)

import Json.Decode exposing (..)


type alias RequestFilter =
    { count : Int
    , name : String
    }


empty : RequestFilter
empty =
    RequestFilter 0 ""


decoder : Decoder RequestFilter
decoder =
    map2 RequestFilter
        (field "count" int)
        (field "name" string)
