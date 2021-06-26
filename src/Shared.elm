module Shared exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    )

import Api.Data exposing (Data)
import Api.Film
import Json.Decode as Json
import Request exposing (Request)


type alias Flags =
    Json.Value



-- INIT


type alias Model =
    { listing : Data Api.Film.Listing
    }


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    let
        model =
            { listing = Api.Data.Loading }
    in
    ( model
    , Cmd.batch
        [ fetchFilmListing
        ]
    )


fetchFilmListing : Cmd Msg
fetchFilmListing =
    Api.Film.list { onResponse = GotFilmListing }



-- UPDATE


type Msg
    = GotFilmListing (Data Api.Film.Listing)


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        GotFilmListing listing ->
            ( { model | listing = listing }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none
