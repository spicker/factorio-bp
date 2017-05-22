module Data.Blueprint exposing (..)

import Ports exposing (..)
import Data.Entity exposing (..)
import Data.Icon exposing (Icon)
import Json.Decode exposing (..)
import Dict exposing (Dict)
import String exposing (dropLeft)
import Base64


type Blueprint
    = Blueprint BlueprintSingle
    | BlueprintBook
        { blueprints : Dict Int BlueprintSingle
        , label : String
        , active_index : Int
        , version : Int
        }


type alias BlueprintSingle =
    { icons : Dict Int Icon
    , entities : Dict Int Entity
    , label : String
    , version : Int
    }



-- type alias BlueprintBook =
--     { blueprints : Dict Int Blueprint
--     , label : String
--     , version : Int
--     }


type EncodedBlueprint
    = EncodedBlueprint String


empty : Blueprint
empty =
    Blueprint { icons = Dict.empty, entities = Dict.empty, label = "", version = 0 }



-- drop 1. char -> base64 decompress -> inflate


decodeBlueprintString : Value -> Result String Blueprint
decodeBlueprintString val =
    Err ""


deBase64String : String -> Result String String
deBase64String =
    Base64.decode << dropLeft 1


decodeBlueprint : EncodedBlueprint -> Blueprint
decodeBlueprint ebp =
    empty


validateString : String -> Maybe EncodedBlueprint
validateString str =
    Nothing


encodeBlueprint : Blueprint -> EncodedBlueprint
encodeBlueprint bp =
    EncodedBlueprint ""
