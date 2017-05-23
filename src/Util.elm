module Util exposing (..)

import Json.Decode exposing (list, map2, map, Decoder)
import Dict exposing (Dict)


dict : Decoder comparable -> Decoder v -> Decoder (Dict comparable v)
dict c =
    map Dict.fromList << list << map2 (,) c
