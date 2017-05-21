module Data.Blueprint exposing (..)

import Data.Entity exposing (..)
import Data.Icon exposing (Icon)
import Json.Decode exposing (..)
import Dict exposing (Dict)


type Blueprint
    = Blueprint
        { icons :
            Dict Int Icon
            -- Dict??
        , entities :
            Dict Int Entity
            -- Dict??
        , label : String
        , version : Int
        }


type alias BlueprintBook =
    { blueprints : Dict Int Blueprint
    , label : String
    , version : Int
    }


type EncodedBlueprint
    = EncodedBlueprint String


empty : Blueprint
empty =
    Blueprint { icons = Dict.empty, entities = Dict.empty, label = "", version = 0 }


decodeBlueprintString : String -> Maybe Blueprint
decodeBlueprintString str =
    Nothing


decodeBlueprint : EncodedBlueprint -> Blueprint
decodeBlueprint ebp =
    empty


validateString : String -> Maybe EncodedBlueprint
validateString str =
    Nothing


encodeBlueprint : Blueprint -> EncodedBlueprint
encodeBlueprint bp =
    EncodedBlueprint ""
