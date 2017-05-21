module Data.Icon exposing (..)


type Icon
    = Icon
        { signal :
            Signal
            -- Dict??
        }


type Signal
    = Signal
        { type_ : String
        , name : String
        }
