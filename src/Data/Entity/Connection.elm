module Data.Entity.Connection exposing (..)

import Json.Decode exposing (..)


type Connection
    = Connection
        { redConnections : List CircuitConnection
        , greenConnections : List CircuitConnection
        }


type CircuitConnection
    = MonoConnection { entityId : Int }
    | MultiConnection { entityId : Int, circuitId : Int }


decoder : Decoder Connection
decoder =
    succeed <| Connection { redConnections = [], greenConnections = [] }
