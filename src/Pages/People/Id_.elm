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
    { id : String
    , person : Data Api.Person.Person
    }


init : Params -> ( Model, Cmd Msg )
init params =
    ( { id = params.id
      , person = Api.Data.Loading
      }
    , fetchPerson params
    )


fetchPerson : Params -> Cmd Msg
fetchPerson params =
    Api.Person.get
        { id = params.id
        , onResponse = GotPerson
        }



-- UPDATE


type Msg
    = GotPerson (Data Api.Person.Person)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotPerson person ->
            ( { model | person = person }
            , Cmd.none
            )



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
    [ Html.div [] <|
        viewPerson
            model.person
    ]


viewPerson : Data Api.Person.Person -> List (Html msg)
viewPerson apiPerson =
    case apiPerson of
        Api.Data.Loading ->
            [ Html.h1 [] [ Html.text "Loading..." ] ]

        Api.Data.NotAsked ->
            [ Html.h1 [] [ Html.text "Not asked..." ] ]

        Api.Data.Success person ->
            viewPersonInfo person

        _ ->
            [ Html.h1 [] [ Html.text "Error..." ] ]


viewPersonInfo : Person -> List (Html msg)
viewPersonInfo person =
    [ Html.h1 [] [ Html.text person.name ]
    , Html.ul []
        [ Html.li []
            [ Html.text "Name: "
            , Html.text person.name
            ]
        , Html.li []
            [ Html.text "Gender: "
            , Html.text person.gender
            ]
        , Html.li []
            [ Html.text "Birth Year: "
            , Html.text person.birthYear
            ]
        , Html.li []
            [ Html.text "Skin Color: "
            , Html.text person.skinColor
            ]
        , Html.li []
            [ Html.text "Eye Color: "
            , Html.text person.eyeColor
            ]
        , Html.li []
            [ Html.text "Height: "
            , Html.text person.height
            ]
        , Html.li []
            [ Html.text "Mass: "
            , Html.text person.mass
            ]
        ]
    ]
