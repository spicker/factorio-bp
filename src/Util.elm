module Util exposing (..)

import Json.Decode exposing (list, map2, map, Decoder)
import Dict exposing (Dict)


dict : Decoder comparable -> Decoder v -> Decoder (Dict comparable v)
dict c =
    map Dict.fromList << list << map2 (,) c


getSize : List ( Int, Int ) -> ( Int, Int )
getSize ls =
    let
        -- smax =
        --     (Maybe.withDefault 0) << List.maximum
        -- smin =
        --     (Maybe.withDefault 0) << List.minimum
        -- lefts =
        --     ls |> List.map Tuple.first
        -- rights =
        --     ls |> List.map Tuple.second
        lsf =
            List.unzip ls |> Tuple.first

        lss =
            List.unzip ls |> Tuple.second

        ( xmin, xmax ) =
            ( Maybe.withDefault 0 (List.minimum lsf), Maybe.withDefault 0 (List.maximum lsf) )

        ( ymin, ymax ) =
            ( Maybe.withDefault 0 (List.minimum lss), Maybe.withDefault 0 (List.maximum lss) )
    in
        ( xmax - xmin , ymax - ymin  )
