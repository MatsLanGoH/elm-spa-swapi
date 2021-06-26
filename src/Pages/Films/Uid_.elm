module Pages.Films.Uid_ exposing (Model, Msg, page)

import Api.Data exposing (Data)
import Api.Film exposing (Film)
import Gen.Params.Films.Uid_ exposing (Params)
import Html exposing (Html)
import Page
import Request
import Shared
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ req =
    Page.element
        { init = init req.params
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { uid : String
    , film : Data Api.Film.Film
    }


init : Params -> ( Model, Cmd Msg )
init params =
    ( { uid = params.uid
      , film = Api.Data.Loading
      }
    , fetchFilm params
    )


fetchFilm : Params -> Cmd Msg
fetchFilm params =
    Api.Film.get
        { uid = params.uid
        , onResponse = GotFilm
        }



-- UPDATE


type Msg
    = GotFilm (Data Api.Film.Film)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotFilm film ->
            ( { model | film = film }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = getFilmTitle model
    , body = UI.layout <| viewBody model
    }


getFilmTitle : Model -> String
getFilmTitle model =
    case model.film of
        Api.Data.Success film ->
            film.properties.title

        _ ->
            "Film Details"


viewBody : Model -> List (Html msg)
viewBody model =
    [ Html.div [] <| viewFilm model.film ]


viewFilm : Data Api.Film.Film -> List (Html msg)
viewFilm apiFilm =
    case apiFilm of
        Api.Data.Loading ->
            [ Html.h1 [] [ Html.text "Loading..." ] ]

        Api.Data.NotAsked ->
            [ Html.h1 [] [ Html.text "Not asked..." ] ]

        Api.Data.Success film ->
            viewFilmInfo film

        _ ->
            [ Html.h1 [] [ Html.text "Error..." ] ]


viewFilmInfo : Film -> List (Html msg)
viewFilmInfo film =
    let
        fp =
            film.properties
    in
    [ Html.h1 [] [ Html.text fp.title ]
    , Html.p []
        [ Html.text "Opening crawl: "
        , Html.text fp.openingCrawl
        ]
    , Html.ul []
        [ Html.li []
            [ Html.text "Director: "
            , Html.text fp.director
            ]
        , Html.li [] [ Html.text "Producer: ", Html.text fp.producer ]
        , Html.li [] [ Html.text "Release Date: ", Html.text fp.release_date ]
        ]
    ]
