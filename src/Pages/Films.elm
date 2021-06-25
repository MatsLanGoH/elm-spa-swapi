module Pages.Films exposing (Model, Msg, page)

import Api.Data exposing (Data)
import Api.Film exposing (Film, Listing)
import Gen.Params.Films exposing (Params)
import Gen.Route as Route exposing (Route)
import Html exposing (Html)
import Html.Attributes as Attr
import Page
import Request
import Shared
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { listing : Data Api.Film.Listing
    }


init : ( Model, Cmd Msg )
init =
    let
        model =
            { listing = Api.Data.Loading }
    in
    ( model, fetchFilmListing )


fetchFilmListing : Cmd Msg
fetchFilmListing =
    Api.Film.list { onResponse = GotFilmListing }



-- UPDATE


type Msg
    = GotFilmListing (Data Api.Film.Listing)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotFilmListing listing ->
            ( { model | listing = listing }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Films"
    , body = UI.layout <| viewBody model
    }


viewBody : Model -> List (Html msg)
viewBody model =
    [ Html.h1 [] [ Html.text "Star Wars Films" ]
    , Html.div []
        [ Html.ul [] (viewListing model.listing)
        ]
    ]


viewListing : Data Api.Film.Listing -> List (Html msg)
viewListing filmListing =
    case filmListing of
        Api.Data.Loading ->
            [ Html.text "Loading... " ]

        Api.Data.NotAsked ->
            [ Html.text "Not asked" ]

        Api.Data.Success listing ->
            viewFilmList listing.films

        _ ->
            []


viewFilmList : List Film -> List (Html msg)
viewFilmList filmListing =
    [ Html.div [] (List.map viewFilmInfo filmListing)
    ]


viewFilmInfo : Film -> Html msg
viewFilmInfo film =
    Html.div []
        [ Html.a
            [ Attr.href (Route.toHref <| Route.Films__Uid_ { uid = film.id }) ]
            [ Html.h3 []
                [ Html.text <|
                    "Episode "
                        ++ String.fromInt film.properties.episodeId
                        ++ ": "
                        ++ film.properties.title
                ]
            ]
        , Html.p [] [ Html.text film.properties.openingCrawl ]
        , Html.details []
            [ Html.ul []
                [ Html.li [] [ Html.text "Director: ", Html.text film.properties.director ]
                , Html.li [] [ Html.text "Producer: ", Html.text film.properties.producer ]
                , Html.li [] [ Html.text "Release Date: ", Html.text film.properties.release_date ]
                ]
            ]
        , Html.hr [] []
        ]
