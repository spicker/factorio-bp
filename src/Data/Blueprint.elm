module Data.Blueprint exposing (..)

import Ports exposing (..)
import Data.Entity as Entity exposing (..)
import Data.Icon as Icon exposing (Icon)
import Data.Tile as Tile exposing (Tile)
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
    { icons : List Icon
    , entities : List Entity
    , tiles : List Tile
    , label : String
    , version : Int
    }


type alias BlueprintMulti =
    { blueprints : List BlueprintSingle
    , label : String
    , active_index : Int
    , version : Int
    }


type EncodedBlueprint
    = EncodedBlueprint String


empty : Blueprint
empty =
    Blueprint <| BlueprintSingle [] [] [] "" 0



-- drop 1. char -> base64 decompress -> inflate


decodeBase64 : String -> Result String String
decodeBase64 =
    Base64.decode << dropLeft 1


decodeJson : Value -> Result String Blueprint
decodeJson val =
    decodeValue decoder val


-- idDict : Decoder a -> Decoder (Dict Int a)
-- idDict a =


decoder : Decoder Blueprint
decoder =
    let
        blueprintSingle : Decoder BlueprintSingle
        blueprintSingle =
            decode BlueprintSingle
                |> optional "icons" (list Icon.decoder) []
                |> optional "entities" (list Entity.decoder) []
                |> optional "tiles" (list Tile.decoder) []
                |> required "label" string
                |> required "version" int

        blueprintMulti : Decoder BlueprintMulti
        blueprintMulti =
            decode BlueprintMulti
                |> optional "blueprints" (list blueprintSingle) []
                |> required "label" string
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
