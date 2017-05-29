module Data.GameEntity exposing (..)

import Dict exposing (Dict)


type alias GameEntities =
    Dict String GameEntity


type alias GameEntity =
    { size : ( Int, Int )
    , label : String
    , sprite : Maybe String
    }


genericGameEntity : String -> GameEntity
genericGameEntity label =
    GameEntity ( 1, 1 ) label Nothing


exGE1 =
    GameEntity ( 1, 1 ) "Express Transport Belt" (Just "assets/express-transport-belt.png")


exGE2 =
    GameEntity ( 2, 1 ) "Express Splitter" Nothing


exGE3 =
    GameEntity ( 3, 3 ) "example-entity3" Nothing


exGES =
    Dict.singleton "express-transport-belt" exGE1
        |> Dict.insert "express-splitter" exGE2
