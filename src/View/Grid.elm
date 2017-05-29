module View.Grid exposing (..)

import Util
import Data.Blueprint as BP exposing (Blueprint)
import Html exposing (..)
import Html.Attributes exposing (..)
import Dict exposing (Dict)
import List exposing (..)
import Basics


type alias GridTile =
    { occupied : Bool }


type alias Grid =
    Dict ( Int, Int ) GridTile


(=>) =
    (,)



-- n =
--     40


init : ( Int, Int ) -> Grid
init ( n, m ) =
    let
        center =
            \a -> ( negate (a // 2), a // 2 )

        ( nn, np ) =
            n |> center

        ( mn, mp ) =
            m |> center
    in
        range nn np
            |> concatMap
                (\x ->
                    range mn mp
                        |> concatMap (\y -> [ ( x, y ) ])
                )
            |> List.map (flip (,) (GridTile False))
            |> Dict.fromList


fromBlueprint : Blueprint -> Grid
fromBlueprint bp =
    BP.occupiedTiles bp
        |> List.map (flip (,) (GridTile True))
        |> Dict.fromList
        |> (flip Dict.union) (init <| BP.getSize bp)


getSize : Grid -> ( Int, Int )
getSize =
    Util.getSize << Dict.keys


view : Grid -> Html msg
view g =
    let
        ( n, m ) =
            getSize g

        wh =
            if ( n, m ) == ( 0, 0 ) then
                [ "width" => "0vh", "height" => "0vh" ]
            else
                [ "width" => (toString ((toFloat n) / (toFloat m) * 50) ++ "vh"), "height" => "50vh" ]

        ( xmin, ymin ) =
            Dict.keys g |> Maybe.withDefault ( 0, 0 ) << List.minimum

        ( xmax, ymax ) =
            Dict.keys g |> Maybe.withDefault ( 0, 0 ) << List.maximum

        gridStr =
            \str x acc -> acc ++ str ++ toString x ++ "-start] 1fr [" ++ str ++ toString x ++ "-end "

        columns =
            List.range xmin xmax |> List.foldl (gridStr "column") "[" |> flip (++) "]"

        rows =
            List.range ymin ymax |> List.foldl (gridStr "row") "[" |> flip (++) "]"
    in
        div
            [ class "grid-container"
            , style <|
                append wh
                    [ "grid-template-rows" => rows
                    , "grid-template-columns" => columns
                    ]
            ]
            (List.map gridItem (Dict.toList g))


gridItem : ( ( Int, Int ), GridTile ) -> Html msg
gridItem ( ( x, y ), gt ) =
    let
        occ =
            if gt == GridTile True then
                (class "grid-item occupied")
            else
                (class "grid-item")

        str s n =
            s ++ toString n ++ "-start / " ++ s ++ toString n ++ "-end"
    in
        div
            [ occ
            , style
                [ "grid-row" => str "row" y
                , "grid-column" => str "column" x
                ]
            ]
            []
