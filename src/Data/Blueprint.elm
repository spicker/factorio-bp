module Data.Blueprint exposing (..)

import Util
import Data.Entity as Entity exposing (..)
import Data.Signal as Signal exposing (Signal)
import Data.Tile as Tile exposing (Tile)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Dict exposing (Dict(..))
import String exposing (dropLeft)
import Base64
import Tuple exposing (first, second)


-- import Basics exposing (floor)


type Blueprint
    = Blueprint BlueprintSingle
    | BlueprintBook BlueprintMulti


type alias BlueprintSingle =
    { icons : Dict Int Signal
    , entities : Dict Int Entity
    , tiles : Dict ( Int, Int ) Tile
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
    Blueprint <| emptySingle


emptySingle : BlueprintSingle
emptySingle =
    BlueprintSingle Dict.empty Dict.empty Dict.empty "" 0



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
        position : Decoder a -> Decoder ( a, a )
        position da =
            map2 (,)
                (at [ "position", "x" ] da)
                (at [ "position", "y" ] da)

        blueprintSingle : Decoder BlueprintSingle
        blueprintSingle =
            decode BlueprintSingle
                |> optional "icons" (Util.dict (field "index" int) (field "signal" Signal.decoder)) Dict.empty
                |> optional "entities" (Util.dict (field "entity_number" int) Entity.decoder) Dict.empty
                |> optional "tiles" (Util.dict (position int) Tile.decoder) Dict.empty
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



-- getSize : Blueprint -> ( ( Int, Int ), ( Int, Int ) )
-- getSize bp =
--     let
--         x1 px a =
--             min a (floor px)
--         y1 py a =
--             min a (floor py)
--         x2 px a =
--             max a (ceiling px)
--         y2 py a =
--             max a (ceiling py)
--         bpsSize bps =
--             List.foldr
--                 (\( px, py ) ( ( ax1, ay1 ), ( ax2, ay2 ) ) ->
--                     ( ( x1 px ax1, y1 py ay1 ), ( x2 px ax2, y2 py ay2 ) )
--                 )
--                 ( ( 0, 0 ), ( 0, 0 ) )
--                 (List.map .position (Dict.values bps.entities))
--         -- bpmSize bpm =
--         --     case bpm of
--         --         Just bps ->
--         --             bpsSize bps
--         --         Nothing ->
--         --             ( ( 0, 0 ), ( 0, 0 ) )
--         bps =
--             getActiveBlueprint bp
--     in
--         -- case bp of
--         --     Blueprint bps ->
--         --         bpsSize bps
--         --     BlueprintBook bpm ->
--         --         bpmSize (Dict.get bpm.active_index bpm.blueprints)
--         bpsSize bps
-- getAbsoluteSize : Blueprint -> ( Int, Int )
-- getAbsoluteSize =
--     (\( ( x1, y1 ), ( x2, y2 ) ) -> ( x2 - x1 + 1, y2 - y1 + 1 )) << getSize


getSize : Blueprint -> ( Int, Int )
getSize =
    occupiedTiles >> Util.getSize


getActiveBlueprint : Blueprint -> BlueprintSingle
getActiveBlueprint bp =
    case bp of
        BlueprintBook bpb ->
            Maybe.withDefault
                emptySingle
                (Dict.get bpb.active_index bpb.blueprints)

        Blueprint bps ->
            bps


occupiedTiles : Blueprint -> List ( Int, Int )
occupiedTiles bp =
    let
        bps =
            getActiveBlueprint bp

        f : Entity -> List ( Int, Int ) -> List ( Int, Int )
        f e acc =
            let
                ( x, y ) =
                    e.position

                (( xf, yf ) as tf) =
                    ( floor x, floor y )

                (( xc, yc ) as tc) =
                    ( ceiling x, ceiling y )

                isWhole a =
                    (ceiling a) - (floor a) |> (==) 0
            in
                case ( isWhole x, isWhole y ) of
                    ( True, True ) ->
                        tf :: acc

                    otherwise ->
                        [ tf, tc ] ++ acc
    in
        Dict.values bps.entities
            |> List.foldr f []
