module View.GameEntity exposing (..)

import Dict exposing (Dict)


type alias GameEntities =
    Dict String GameEntity


type alias GameEntity =
    { size : ( Int, Int )
    , label : String
    , sprite : Maybe String
    , attributes : List ( String, String )
    }


genericGameEntity : String -> GameEntity
genericGameEntity label =
    GameEntity ( 1, 1 ) label Nothing []


position : Int -> Int -> List ( String, String )
position top left =
    [ "top" => (toString top ++ "px")
    , "left" => (toString left ++ "px")
    ]


(=>) =
    (,)


exGE1 =
    GameEntity
        ( 1, 1 )
        "Transport Belt"
        (Just "assets/complete-east2.png")
        ((position -6 -20) ++ [ "z-index" => "0" ])


exGE2 =
    GameEntity ( 2, 1 ) "Express Splitter" (Just "assets/express-splitter.png") [ "margin" => "0px 0 0px 0px" ]


exGE3 =
    GameEntity ( 3, 3 ) "example-entity3" Nothing []


exGES =
    Dict.singleton "transport-belt" exGE1
        |> Dict.insert "express-splitter" exGE2
