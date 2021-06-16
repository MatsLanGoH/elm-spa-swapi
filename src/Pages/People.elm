module Pages.People exposing (Model, Msg, page)

import Api.PeopleIndex exposing (PeopleIndex)
import Effect exposing (Effect)
import Gen.Params.People exposing (Params)
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
    Page.advanced
        { init = init shared
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { peopleList : List PeopleIndex
    }


mockPeople : List PeopleIndex
mockPeople =
    -- TODO replace with actual data
    List.map (\a -> PeopleIndex (Tuple.first a) (Tuple.second a))
        [ ( "1", "Luke Skywalker" )
        , ( "2", "C-3PO" )
        , ( "3", "R2-D2" )
        , ( "4", "Darth Vader" )
        , ( "5", "Leia Organa" )
        ]


init : Shared.Model -> ( Model, Effect Msg )
init shared =
    let
        model =
            { peopleList = mockPeople
            }
    in
    ( model, Effect.none )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "People Index"
    , body = UI.layout <| viewBody model.peopleList
    }


viewBody : List PeopleIndex -> List (Html msg)
viewBody peopleList =
    [ Html.h1 [] [ Html.text "People Index" ]
    , Html.div []
        [ Html.p []
            [ Html.text "This is a list of people in the SW universe"
            ]
        ]
    , Html.div []
        [ Html.ul [] (viewPeopleList peopleList)
        ]
    ]


viewPeopleList : List PeopleIndex -> List (Html msg)
viewPeopleList peopleList =
    let
        viewPeopleLinkItem : PeopleIndex -> Html msg
        viewPeopleLinkItem peopleIndex =
            Html.li []
                [ Html.a
                    [ Attr.href (Route.toHref <| Route.People__Id_ { id = peopleIndex.uid }) ]
                    [ Html.text peopleIndex.name ]
                ]
    in
    List.map viewPeopleLinkItem peopleList
