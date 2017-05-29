module Main exposing (..)

import View.Grid as Grid
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
    , tiles : Dict ( Int, Int ) Bool
    , blueprintString : String
    }


model : Model
model =
    { statusText = ""
    , blueprint = BP.empty
    , tiles = Dict.empty
    , blueprintString = ""
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
    | BpInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        DecodeBlueprint ->
            case decodeString value model.blueprintString of
                Err _ ->
                    case BP.decodeBase64 model.blueprintString of
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
            { model | statusText = "Created New Blueprint", blueprintString = "", blueprint = BP.empty } ! []

        EncodeBlueprint ->
            update NoOp model

        InflatedValue val ->
            case BP.decodeJson <| Debug.log "value: " val of
                Ok bp ->
                    ( { model | blueprint = bp }, Cmd.none )

                Err e ->
                    update (Error e) model

        BpInput str ->
            ( { model | blueprintString = str }, Cmd.none )
            



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "blueprint-input" ]
            [ textarea [ onInput BpInput, HA.rows 5, HA.cols 40 ] []
            , button [ onClick DecodeBlueprint ] [ text "decode" ]
            , text model.statusText
            ]
        , Grid.view (Grid.fromBlueprint model.blueprint)
        , div []
            [ text <| toString model.blueprint ]
        ]



-- grid : List (Html Msg) -> Html Msg
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    inflated InflatedValue
