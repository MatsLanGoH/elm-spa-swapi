module Pages.People.Id_ exposing (Model, Msg, page)

import Api.Data exposing (Data)
import Api.Person exposing (Person)
import Gen.Params.People.Id_ exposing (Params)
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
        { init = init req.params
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { id : String }


init : Params -> ( Model, Cmd Msg )
init params =
    ( { id = params.id }, Cmd.none )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Person Detail " ++ model.id
    , body = UI.layout <| viewBody model
    }


viewBody : Model -> List (Html msg)
viewBody model =
    [ Html.h1 [] [ Html.text ("People detail: " ++ model.id) ]
    , Html.div []
        [ Html.p []
            [ Html.text "People details will go here" ]
        ]
    ]
