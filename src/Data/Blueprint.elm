module Data.Blueprint exposing (..)

import Util
import Data.Entity as Entity exposing (..)
import Data.Icon as Icon exposing (Icon)
import Data.Tile as Tile exposing (Tile)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Dict exposing (Dict(..))
import String exposing (dropLeft)
import Base64


type Blueprint
    = Blueprint BlueprintSingle
    | BlueprintBook BlueprintMulti


type alias BlueprintSingle =
    { icons : Dict Int Icon
    , entities : Dict Int Entity
    , tiles : Dict ( Float, Float ) Tile
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
    Blueprint <| BlueprintSingle Dict.empty Dict.empty Dict.empty "" 0



-- drop 1. char -> base64 decompress -> inflate


decodeBase64 : String -> Result String String
decodeBase64 =
    Base64.decode << dropLeft 1


decodeJson : Value -> Result String Blueprint
decodeJson val =
    decodeValue decoder val


decoder : Decoder Blueprint
decoder =
    let
        blueprintSingle : Decoder BlueprintSingle
        blueprintSingle =
            decode BlueprintSingle
                |> optional "icons" (Util.dict (field "index" int) Icon.decoder) Dict.empty
                |> optional "entities" (Util.dict (field "entity_number" int) Entity.decoder) Dict.empty
                |> optional "tiles" (Util.dict (map2 (,) (at [ "position", "x" ] float) (at [ "position", "y" ] float)) Tile.decoder) Dict.empty
                |> optional "label" string ""
                |> required "version" int

        blueprintMulti : Decoder BlueprintMulti
        blueprintMulti =
            decode BlueprintMulti
                |> optional "blueprints" (Util.dict (field "index" int) (field "blueprint" blueprintSingle)) Dict.empty
                |> optional "label" string ""
                |> required "active_index" int
                |> required "version" int
    in
        oneOf
            [ field "blueprint" blueprintSingle |> andThen (succeed << Blueprint)
            , field "blueprint_book" blueprintMulti |> andThen (succeed << BlueprintBook)
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
