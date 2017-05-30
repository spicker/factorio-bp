module Util exposing (..)

import Json.Decode exposing (list, map2, map, Decoder)
import Dict exposing (Dict)


dict : Decoder comparable -> Decoder v -> Decoder (Dict comparable v)
dict c =
    map Dict.fromList << list << map2 (,) c


getSize : List ( Int, Int ) -> ( Int, Int )
getSize ls =
    let
        ( xmin, xmax ) =
            getXRange ls

        ( ymin, ymax ) =
            getYRange ls
    in
        ( xmax - xmin, ymax - ymin )


getXRange : List ( Int, Int ) -> ( Int, Int )
getXRange ls =
    let
        lsf =
            List.unzip ls |> Tuple.first
    in
        ( Maybe.withDefault 0 (List.minimum lsf), Maybe.withDefault 0 (List.maximum lsf) )


getYRange : List ( Int, Int ) -> ( Int, Int )
getYRange ls =
    let
        lss =
            List.unzip ls |> Tuple.second
    in
        ( Maybe.withDefault 0 (List.minimum lss), Maybe.withDefault 0 (List.maximum lss) )
