module View.Grid exposing (..)

import Util
import View.GameEntity as GameEntity exposing (GameEntity, GameEntities, genericGameEntity)
import Data.Blueprint as BP exposing (Blueprint)
import Data.Entity as Entity exposing (Entity)
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


view : Blueprint -> GameEntities -> Html msg
view bp ge =
    let
        g =
            fromBlueprint bp

        ( n, m ) =
            getSize g

        wh =
            if ( n, m ) == ( 0, 0 ) then
                [ "width" => "0vh", "height" => "0vh" ]
            else
                -- [ "width" => (toString ((toFloat n) / (toFloat m) * 50) ++ "vh"), "height" => "50vh" ]
                [ "width" => ((toString ((toFloat n+1) * 68)) ++ "px"), "height" => ((toString ((toFloat m+1) * 68)) ++ "px") ]

        ( xmin, xmax ) =
            Dict.keys g |> Util.getXRange

        ( ymin, ymax ) =
            Dict.keys g |> Util.getYRange

        gridStr =
            \str x acc -> acc ++ str ++ toString x ++ "-start] 68px [" ++ str ++ toString x ++ "-end "

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
            -- (List.map gridItem (Dict.toList g))
            (List.map (gridItem2 ge) (Dict.values (.entities <| BP.getActiveBlueprint bp)))



-- gridItem : ( ( Int, Int ), GridTile ) -> Html msg
-- gridItem ( ( x, y ), gt ) =
--     let
--         occ =
--             if gt == GridTile True then
--                 (class "grid-item occupied")
--             else
--                 (class "grid-item")
--         str s n =
--             s ++ toString n ++ "-start / " ++ s ++ toString n ++ "-end"
--     in
--         div
--             [ occ
--             , style
--                 [ "grid-row" => str "row" y
--                 , "grid-column" => str "column" x
--                 ]
--             ]
--             []


gridItem2 : GameEntities -> Entity -> Html msg
gridItem2 ges entity =
    let
        ( xe, ye ) =
            entity.position

        ge =
            Dict.get entity.name ges |> Maybe.withDefault (genericGameEntity entity.name)

        ( xs, ys ) =
            let
                ( xs, ys ) =
                    ge.size
            in
                case entity.direction of
                    0 ->
                        ( xs, ys )

                    2 ->
                        ( ys, xs )

                    4 ->
                        ( xs, ys )

                    6 ->
                        ( ys, xs )

                    _ ->
                        ( xs, ys )

        fromTo pos size =
            ( pos - (toFloat (size - 1)) / 2 |> floor, pos + (toFloat (size - 1)) / 2 |> floor )

        ( x1, x2 ) =
            fromTo xe xs

        ( y1, y2 ) =
            fromTo ye ys

        str s a b =
            s ++ toString a ++ "-start / " ++ s ++ toString b ++ "-end"

        texture =
            case ge.sprite of
                Just str ->
                    img [ class ("sprite rotate" {- ++ toString (entity.direction * 45) -}), src str, style ge.attributes ] []

                Nothing ->
                    text ""
    in
        div
            [ class "grid-item"
            , style
                [ "grid-row" => str "row" y1 y2
                , "grid-column" => str "column" x1 x2
                ]
            ]
            [ texture ]
