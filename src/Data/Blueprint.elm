module Data.Blueprint exposing (..)

import Ports exposing (..)
import Data.Entity as Entity exposing (..)
import Data.Icon as Icon exposing (Icon)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Json.Decode.Extra exposing (dict2)
import Dict exposing (Dict(..))
import String exposing (dropLeft)
import Base64


type Blueprint
    = Blueprint BlueprintSingle
    | BlueprintBook BlueprintMulti


type alias BlueprintSingle =
    { icons : Dict Int Icon
    , entities : Dict Int Entity
    , label : String
    , version : Int
    }


type alias BlueprintMulti =
    { blueprints : Dict Int BlueprintSingle
    , label : String
    , active_index : Int
    , version : Int
    }


type EncodedBlueprint
    = EncodedBlueprint String


empty : Blueprint
empty =
    Blueprint { icons = Dict.empty, entities = Dict.empty, label = "", version = 0 }



-- drop 1. char -> base64 decompress -> inflate


deBase64String : String -> Result String String
deBase64String =
    Base64.decode << dropLeft 1


decodeBlueprintString : Value -> Result String Blueprint
decodeBlueprintString val =
    decodeValue blueprintDecoder val



-- idDict : Decoder a -> Decoder (Dict Int a)
-- idDict a =


blueprintDecoder : Decoder Blueprint
blueprintDecoder =
    let
        blueprintSingle : Decoder BlueprintSingle
        blueprintSingle =
            decode BlueprintSingle
                |> required "icons" (dict2 int Icon.iconDecoder)
                |> required "entities" (dict2 int Entity.entityDecoder)
                |> required "label" string
                |> required "version" int

        blueprintMulti : Decoder BlueprintMulti
        blueprintMulti =
            decode BlueprintMulti
                |> required "blueprints" (dict2 int blueprintSingle)
                |> required "label" string
                |> required "active_index" int
                |> required "version" int
    in
        oneOf
            [ field "blueprint" blueprintSingle |> andThen (\x -> decode (Blueprint x))
            , field "blueprint_book" blueprintMulti |> andThen (\x -> decode (BlueprintBook x))
            ]


decodeBlueprint : EncodedBlueprint -> Blueprint
decodeBlueprint ebp =
    empty


validateString : String -> Maybe EncodedBlueprint
validateString str =
    Nothing



-- deflate -> base64 compress -> add '0'


encodeBlueprint : Blueprint -> EncodedBlueprint
encodeBlueprint bp =
    EncodedBlueprint ""


encodedBlueprintToString : EncodedBlueprint -> String
encodedBlueprintToString (EncodedBlueprint str) =
    str
