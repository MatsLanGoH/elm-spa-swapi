module Pages.People exposing (Model, Msg, page)

import Api.Data exposing (Data)
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
    , listing : Data Api.PeopleIndex.Listing
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
            , listing = Api.Data.Loading
            }
    in
    ( model, fetchPeopleIndices )


fetchPeopleIndices : Effect Msg
fetchPeopleIndices =
    Effect.fromCmd <| Api.PeopleIndex.list { onResponse = GotPeopleIndices }



-- UPDATE


type Msg
    = GotPeopleIndices (Data Api.PeopleIndex.Listing)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotPeopleIndices listing ->
            ( { model | listing = listing }
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "People Index"
    , body = UI.layout <| viewBody model
    }


viewBody : Model -> List (Html msg)
viewBody model =
    [ Html.h1 [] [ Html.text "People Index" ]
    , Html.div []
        [ Html.p []
            [ Html.text "This is a list of people in the SW universe"
            ]
        ]
    , Html.div []
        [ Html.ul [] (viewPeopleList model.peopleList)
        ]
    , Html.div []
        [ Html.p [] (viewListing model.listing)
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


viewListing : Data Api.PeopleIndex.Listing -> List (Html msg)
viewListing listing =
    case listing of
        Api.Data.Loading ->
            [ Html.text "loading " ]

        Api.Data.NotAsked ->
            [ Html.text "Not asked" ]

        Api.Data.Success peopleListing ->
            viewPeopleList peopleListing.peopleIndices

        _ ->
            []
