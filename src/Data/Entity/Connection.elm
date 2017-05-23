module Data.Entity.Connection exposing (..)

import Json.Decode exposing (..)


type alias Connection =
    { entityId : Int
    , circuitId : Maybe Int
    }


type Id
    = One
    | Two


type Wire
    = Red
    | Green


empty : Connection
empty =
    Connection 0 Nothing


decoder : Decoder Connection
decoder =
    map2 Connection
        (field "entity_id" int)
        (maybe <| field "circuit_id" int)



-- wireDecoder : Decoder Wire
-- wireDecoder =
--     let
--         convert : String -> Decoder Wire
--         convert str =
--             case str of
--                 "red" ->
--                     succeed Red
--                 "green" ->
--                     succeed Green
--                 _ ->
--                     fail "Invalid value for Connection.Wire"
--     in
--         string |> andThen convert
-- connectedToDecoder : Decoder ( Id, Wire )
-- connectedToDecoder =
--     let


idDecoder : Decoder ( Id, Wire )
idDecoder =
    let
        convertId : String -> Decoder ( Id, Wire )
        convertId str =
            case str of
                "1" ->
                    map2 (,) (succeed One) (wireDecoder str)

                "2" ->
                    map2 (,) (succeed Two) (wireDecoder str)

                _ ->
                    map2 (,) (fail "Invalid value for Connection.Id") (wireDecoder str)
    in
        string |> andThen convertId


wireDecoder : String -> Decoder Wire
wireDecoder str =
    let
        convertWire : String -> Decoder Wire
        convertWire str =
            case str of
                "red" ->
                    succeed Red

                "green" ->
                    succeed Green

                _ ->
                    fail "Invalid value for Connection.Wire"
    in
        (field str string) |> andThen convertWire


idDecoder2 : Decoder ( Id, Wire )
idDecoder2 =
    oneOf [ field "1" <| map2 (,) (succeed One) wireDecoder2, field "2" <| map2 (,) (succeed Two) wireDecoder2 ]


wireDecoder2 : Decoder Wire
wireDecoder2 =
    oneOf [ field "red" (succeed Red), field "green" (succeed Green) ]


connectedTo2String : ( Id, Wire ) -> ( String, String )
connectedTo2String ( id, wire ) =
    let
        wireStr =
            case wire of
                Red ->
                    "red"

                Green ->
                    "green"

        idStr =
            case id of
                One ->
                    "1"

                Two ->
                    "2"
    in
        ( idStr, wireStr )



-- in
--     map2 (,) idDecoder wireDecoder
