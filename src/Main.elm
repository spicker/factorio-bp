module Main exposing (..)

import Data.Blueprint as BP exposing (Blueprint, EncodedBlueprint)
import Ports exposing (..)
import Html exposing (..)
import Html.Attributes as HA exposing (class)
import Html.Events exposing (onClick, onInput)
import Dict exposing (Dict)
import Json.Decode exposing (Value, decodeString, value)
import Json.Encode exposing (encode)


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
    , bpTextarea : String
    }


model : Model
model =
    { statusText = ""
    , blueprint = BP.empty
    , blueprintString = BP.encodeBlueprint BP.empty
    , tiles = Dict.empty
    , bpTextarea = ""
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
    | InflatedValue Value
    | BpTextareaInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        DecodeBlueprint ->
            case decodeString value model.bpTextarea of
                Err _ ->
                    case BP.decodeBase64 model.bpTextarea of
                        Ok str ->
                            ( model, inflate str )

                        -- update (Error str) model
                        Err e ->
                            update (Error e) model

                Ok val ->
                    case BP.decodeJson val of
                        Ok bp ->
                            ( { model | blueprint = bp }, Cmd.none )

                        Err e ->
                            update (Error e) model

        Error e ->
            { model | statusText = e } ! []

        NewBlueprint ->
            { model | statusText = "Created New Blueprint", blueprintString = BP.encodeBlueprint BP.empty, blueprint = BP.empty } ! []

        EncodeBlueprint ->
            ( { model | blueprintString = BP.encodeBlueprint model.blueprint }, Cmd.none )

        InflatedValue val ->
            case BP.decodeJson <| Debug.log "value: " val of
                Ok bp ->
                    ( { model | blueprint = bp }, Cmd.none )

                Err e ->
                    update (Error e) model

        BpTextareaInput str ->
            ( { model | bpTextarea = str }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [ class "blueprint-input" ]
            [ textarea [ onInput BpTextareaInput, HA.rows 5, HA.cols 40 ] []
            , button [ onClick DecodeBlueprint ] [ text "decode" ]
            , text model.statusText
            ]
        , div []
            [ text <| toString model.blueprint ]
        ]



-- grid : List (Html Msg) -> Html Msg
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    inflated InflatedValue
