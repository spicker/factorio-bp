module Main exposing (..)

import Html exposing (..)
import Data.Blueprint as BP exposing (Blueprint, EncodedBlueprint)
import Dict exposing (Dict)


main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { statusText : String
    , blueprint : Blueprint
    , blueprintString : EncodedBlueprint
    , tiles : Dict ( Int, Int ) Bool
    }


model : Model
model =
    { statusText = ""
    , blueprint = BP.empty
    , blueprintString = BP.encodeBlueprint BP.empty
    , tiles = Dict.empty
    }



-- UPDATE


type Msg
    = NoOp
    | DecodeBlueprint
    | Error String
    | NewBlueprint
      -- | UpdateBlueprint
    | EncodeBlueprint



-- | GenerateUrl


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        DecodeBlueprint ->
            ( { model | blueprint = BP.decodeBlueprint model.blueprintString }, Cmd.none )

        Error e ->
            { model | statusText = e } ! []

        NewBlueprint ->
            { model | statusText = "Created New Blueprint", blueprintString = BP.encodeBlueprint BP.empty, blueprint = BP.empty } ! []

        EncodeBlueprint ->
            ( { model | blueprintString = BP.encodeBlueprint model.blueprint }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    text "bla"


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
