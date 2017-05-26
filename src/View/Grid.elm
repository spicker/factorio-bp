module View.Grid exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Dict exposing (Dict)
import List exposing (..)


type alias GridTile =
    { occupied : Bool }


type alias Grid =
    Dict ( Int, Int ) GridTile


(=>) =
    (,)


n =
    40


init : ( Int, Int ) -> Grid
init ( n, m ) =
    range 1 n
        |> concatMap (\x -> range 1 m
        |> concatMap (\y -> [ ( x, y ) ]))
        |> List.map (flip (,) (GridTile False))
        |> Dict.fromList


view : Html msg
view =
    div
        [ class "grid-container"
        , style
            [ "grid-template-rows" => ("repeat(" ++ toString n ++ ", 1fr)")
            , "grid-template-columns" => ("repeat(" ++ toString n ++ ", 1fr)")
              -- , "grid-gap" => (toString (4/n) ++ "vh")
            ]
        ]
        (List.map gridItem (Dict.keys (init ( n, n ))))


gridItem : ( Int, Int ) -> Html msg
gridItem ( x, y ) =
    div
        [ class "grid-item"
        , style
            [ "grid-row" => (toString y ++ "/" ++ toString (y + 1))
            , "grid-column" => (toString x ++ "/" ++ toString (x + 1))
            ]
        ]
        []
