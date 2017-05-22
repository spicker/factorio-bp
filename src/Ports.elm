port module Ports exposing (..)

import Json.Decode exposing (Value)


port inflate : String -> Cmd msg


port inflated : (Value -> msg) -> Sub msg
