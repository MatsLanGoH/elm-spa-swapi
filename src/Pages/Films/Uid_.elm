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
page shared req =
    Page.element
        { init = init req.params
        , update = update
        , view = view shared
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
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = getFilmTitle model
    , body = UI.layout <| viewBody shared model
    }


getFilmTitle : Model -> String
getFilmTitle model =
    case model.film of
        Api.Data.Success film ->
            film.properties.title

        _ ->
            "Film Details"


viewBody : Shared.Model -> Model -> List (Html msg)
viewBody shared model =
    [ Html.div [] <| viewFilm shared.listing model ]


getFilm : Model -> Api.Film.Listing -> Maybe Film
getFilm model filmListing =
    filmListing.films
        |> List.filter (\film -> film.uid == model.uid)
        |> List.head


viewFilm : Data Api.Film.Listing -> Model -> List (Html msg)
viewFilm listing model =
    case listing of
        Api.Data.Loading ->
            [ Html.h1 [] [ Html.text "Loading..." ] ]

        Api.Data.NotAsked ->
            [ Html.h1 [] [ Html.text "Not asked..." ] ]

        Api.Data.Success filmListing ->
            let
                apiFilm =
                    getFilm model filmListing
            in
            case apiFilm of
                Just film ->
                    viewFilmInfo film

                Nothing ->
                    [ Html.h1 [] [ Html.text "Not asked..." ] ]

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
