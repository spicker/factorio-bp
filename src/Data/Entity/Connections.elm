module Data.Entity.Connections exposing (..)

import Json.Decode exposing (..)


type alias Connection =
    { entityId : Int
    , circuitId : Maybe Int
    }


type alias Connections =
    List ( ( Id, Wire ), List Connection )


type Id
    = One
    | Two


type Wire
    = Red
    | Green


empty : Connection
empty =
    Connection 0 Nothing


connectionDecoder : Decoder Connection
connectionDecoder =
    map2 Connection
        (field "entity_id" int)
        (maybe <| field "circuit_id" int)


decoder : Decoder Connections
decoder =
    let
        -- convertWire : Id -> Decoder Wire
        -- convertWire id =
        --     case id of
        --         One ->
        --             field "1" wireDecoder
        --         Two ->
        --             field "2" wireDecoder
        -- connectedTo =
        --     map2 (,) idDecoder (idDecoder |> andThen convertWire)
        -- connlist : Decoder (List Connection)
        -- connlist =
        --     connectedTo |> andThen convertConn
        -- convertConn : ( Id, Wire ) -> Decoder (List Connection)
        -- convertConn ( i, w ) =
        --     at [ idToString i, wireToString w ] connectionDecoder |> list
        convertConn : List ( String, List ( String, List Connection ) ) -> Decoder Connections
        convertConn ls =
            ls
                |> List.foldl
                    (\( i, wl ) acc ->
                        (List.foldl
                            (\( w, cl ) acc2 ->
                                ( ( i, w ), cl ) :: acc2
                            )
                            []
                            wl
                        )
                            :: acc
                    )
                    []
                |> List.concat
                |> convertCt

        -- |> succeed
        -- wireList : List (String, List Connection) -> Decoder (List (Wire,List Connection))
        -- wireList ls =
        --     List.map
        --         (\(s,cl) ->
        --             case s of
        --                 "green" -> (Green, cl)
        --                 "red" -> (Red, cl))
        convertCt : List ( ( String, String ), List Connection ) -> Decoder Connections
        convertCt ls =
            case ls of
                [] ->
                    succeed []

                ( ct, cl ) :: cs ->
                    case connectedToDecoder ct of
                        Ok dct ->
                            -- succeed <| ( dct, cl ) :: convertCt cs
                            convertCt cs |> andThen ((::) ( dct, cl ) >> succeed)

                        Err e ->
                            fail e
    in
        -- map2 (,) connectedTo connlist |> list
        keyValuePairs (keyValuePairs (list connectionDecoder))
            |> andThen convertConn



-- |> andThen convertCt
-- decoder2 : Decoder Connections
-- decoder2 =
--     let
--     in
--         oneOf
--             [ ]
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
-- idDecoder : Decoder ( Id, Wire )
-- idDecoder =
--     let
--         convertId : String -> Decoder ( Id, Wire )
--         convertId str =
--             case str of
--                 "1" ->
--                     map2 (,) (succeed One) (wireDecoder str)
--                 "2" ->
--                     map2 (,) (succeed Two) (wireDecoder str)
--                 _ ->
--                     fail "Invalid value for Connection.Id"
--     in
--         string |> andThen convertId
-- wireDecoder : String -> Decoder Wire
-- wireDecoder str =
--     let
--         convertWire : String -> Decoder Wire
--         convertWire str =
--             case str of
--                 "red" ->
--                     succeed Red
--                 "green" ->
--                     succeed Green
--                 _ ->
--                     fail "Invalid value for Connection.Wire"
--     in
--         (field str string) |> andThen convertWire
-- connectedToDecoder : Decoder ( Id, Wire )
-- connectedToDecoder =
--     oneOf [ field "1" <| map2 (,) (succeed One) wireDecoder, field "2" <| map2 (,) (succeed Two) wireDecoder ]


idDecoder : Decoder Id
idDecoder =
    oneOf [ field "1" (succeed One), field "2" (succeed Two) ]


idDecoder2 : String -> Decoder Id
idDecoder2 str =
    case str of
        "1" ->
            succeed One

        "2" ->
            succeed Two

        _ ->
            fail "Invalid value for Connection.Id"


wireDecoder : Decoder Wire
wireDecoder =
    oneOf [ field "red" (succeed Red), field "green" (succeed Green) ]


wireDecoder2 : String -> Decoder Wire
wireDecoder2 str =
    case str of
        "red" ->
            succeed Red

        "green" ->
            succeed Green

        _ ->
            fail "Invalid value for Connection.Wire"


connectedToDecoder : ( String, String ) -> Result String ( Id, Wire )
connectedToDecoder ( istr, wstr ) =
    let
        ri =
            case istr of
                "1" ->
                    Just One

                "2" ->
                    Just Two

                _ ->
                    Nothing

        rw =
            case wstr of
                "red" ->
                    Just Red

                "green" ->
                    Just Green

                _ ->
                    Nothing
    in
        case ( ri, rw ) of
            ( Just id, Just wire ) ->
                Ok ( id, wire )

            otherwise ->
                Err "Invalid Connection.Id or Connection.Wire"



-- connectedTo2String : ( Id, Wire ) -> ( String, String )
-- connectedTo2String ( id, wire ) =
--     let
--         wireStr =
--             case wire of
--                 Red ->
--                     "red"
--                 Green ->
--                     "green"
--         idStr =
--             case id of
--                 One ->
--                     "1"
--                 Two ->
--                     "2"
--     in
--         ( idStr, wireStr )


wireToString : Wire -> String
wireToString =
    String.toLower << toString


idToString : Id -> String
idToString id =
    case id of
        One ->
            "1"

        Two ->
            "2"
