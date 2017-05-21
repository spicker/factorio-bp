module Data.Entity.Connection exposing (..)


type Connection
    = Connection
        { redConnections : List CircuitConnection
        , greenConnections : List CircuitConnection
        }


type CircuitConnection
    = MonoConnection { entityId : Int }
    | MultiConnection { entityId : Int, circuitId : Int }
