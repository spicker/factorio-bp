module View.GameEntity exposing (..)

import Dict exposing (Dict)
import Data.Entity exposing (Entity)
import View.GameEntity.Texture as Texture exposing (Texture)
import Html exposing (..)
import Html.Attributes exposing (class, style, src)


type alias GameEntities =
    Dict String GameEntity


type alias GameEntity =
    { size : ( Int, Int )
    , label : String
    , textures : Dict Int Texture
    , attributes : List ( String, String )
    }


genericGameEntity : String -> GameEntity
genericGameEntity label =
    GameEntity ( 1, 1 ) label Dict.empty []


position : Int -> Int -> List ( String, String )
position top left =
    [ "top" => (toString top ++ "px")
    , "left" => (toString left ++ "px")
    ]


view : Int -> Entity -> GameEntity -> Html msg
view scale entity ge =
    let
        ( xe, ye ) =
            entity.position

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
            Dict.map 
    in
        div
            [ class "grid-item"
            , style
                [ "grid-row" => str "row" y1 y2
                , "grid-column" => str "column" x1 x2
                ]
            ]
            [ texture ]


(=>) =
    (,)


exGE1 =
    GameEntity
        ( 1, 1 )
        "Transport Belt"
        (Dict.singleton 2
            (Texture [ Texture.Sprite "assets/complete-east2.png"
                ((position -6 -20) ++ [ "z-index" => "0" ])]
            )
        )
        []


exGE2 =
    GameEntity
        ( 2, 1 )
        "Express Splitter"
        (Dict.singleton 0
            (Texture "assets/express-splitter.png" [ "margin" => "0px 0 0px 0px" ])
        )
        []


exGE3 =
    GameEntity ( 3, 3 ) "example-entity3" Dict.empty []


exGES =
    Dict.singleton "transport-belt" exGE1
        |> Dict.insert "express-splitter" exGE2
