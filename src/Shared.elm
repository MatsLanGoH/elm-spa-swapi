module Shared exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    )

import Api.Data exposing (Data)
import Api.Film exposing (Film, Listing)
import Json.Decode as Json
import Request exposing (Request)


type alias Flags =
    Json.Value


type alias Model =
    { listing : Data Api.Film.Listing
    }


type Msg
    = NoOp


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    let
        model =
            { listing = Api.Data.Loading }
    in
    ( model, Cmd.none )


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none
