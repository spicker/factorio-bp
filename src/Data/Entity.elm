module Data.Entity exposing (..)

import Util
import Data.Entity.RequestFilter as RequestFilter exposing (RequestFilter)
import Data.Entity.Connections as Connections exposing (Connections)
import Data.Entity.Module as Module exposing (Module)
import Data.Entity.ControlBehaviour as ConrolBehaviour exposing (ControlBehaviour)
import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional, requiredAt, custom, optionalAt)


type alias Entity =
    { entity_number : Int
    , name : String
    , position : ( Float, Float )
    , direction : Int
    , connections : Connections
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

        -- connections : ( Id, Wire ) -> Decoder (List Connections)
        -- connections ct =
        --     let
        --         ( connId, connWire ) =
        --             Connections.connectedTo2String ct
        --     in
        --         at [ connId, connWire ] (list Connections.decoder)
        -- ctD =
        --     Connections.idDecoder2
        -- conn =
        --     map2 (,) ctD (ctD |> andThen connections)
    in
        decode Entity
            |> required "entity_number" int
            |> required "name" string
            |> custom position
            |> optional "direction" int 0
            |> optional "connections" Connections.decoder []
            |> optional "items" (Util.dict (field "item" string) Module.decoder) Dict.empty
            |> optional "request_filters" (Util.dict (field "index" int) RequestFilter.decoder) Dict.empty
