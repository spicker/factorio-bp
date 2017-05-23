module Data.Entity exposing (..)

import Util
import Data.Entity.RequestFilter as RequestFilter exposing (RequestFilter)
import Data.Entity.Connection as Connection exposing (Connection, Id(..), Wire(..))
import Data.Entity.Module as Module exposing (Module)
import Data.Entity.ControlBehaviour as ConrolBehaviour exposing (ControlBehaviour)
import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional, requiredAt, custom, optionalAt)


type alias Entity =
    { name : String
    , position : ( Float, Float )
    , direction : Int
    , connections : Maybe ( ( Id, Wire ), List Connection )
    , modules : Dict String Module
    , request_filters : Dict Int RequestFilter
    }



-- empty : Entity
-- empty =
--     Entity "" ( 0, 0 ) 0 [] Dict.empty Dict.empty


decoder : Decoder Entity
decoder =
    let
        position : Decoder ( Float, Float )
        position =
            decode (,)
                |> requiredAt [ "position", "x" ] float
                |> requiredAt [ "position", "y" ] float

        connection : ( Id, Wire ) -> Decoder (List Connection)
        connection ct =
            let
                ( connId, connWire ) =
                    Connection.connectedTo2String ct
            in
                at [ connId, connWire ] (list Connection.decoder)

        ctD =
            Connection.idDecoder2

        conn =
            map2 (,) ctD (ctD |> andThen connection)
    in
        decode Entity
            |> required "name" string
            |> custom position
            |> optional "direction" int 0
            |> custom (maybe <| field "connections" conn)
            |> optional "items" (Util.dict (field "item" string) Module.decoder) Dict.empty
            |> optional "request_filters" (Util.dict (field "index" int) RequestFilter.decoder) Dict.empty
