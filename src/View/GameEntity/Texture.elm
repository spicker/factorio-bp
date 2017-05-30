module View.GameEntity.Texture exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Texture =
    List Sprite


type alias Sprite =
    { url : String
    , attributes : List ( String, String )
    }


empty : Sprite
empty =
    Sprite "" []


(=>) =
    (,)


view : Int -> Sprite -> Html msg
view scale sprite =
    img
        [ src sprite.url
        , style sprite.attributes
        ]
        []
