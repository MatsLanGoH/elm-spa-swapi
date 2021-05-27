module Pages.People exposing (view)

import Gen.Route as Route exposing (Route)
import Html exposing (Html)
import Html.Attributes as Attr
import UI
import View exposing (View)


type alias PeopleIndex =
    -- TODO: move to API / Data
    { uid : String
    , name : String

    -- , url : String
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


view : View msg
view =
    { title = "People Index"
    , body = UI.layout viewBody
    }


viewBody : List (Html msg)
viewBody =
    [ Html.h1 [] [ Html.text "People Index" ]
    , Html.div []
        [ Html.p []
            [ Html.text "This is a list of people in the SW universe"
            ]
        ]
    , Html.div []
        [ Html.ul [] viewPeopleList
        ]
    ]


viewPeopleList : List (Html msg)
viewPeopleList =
    let
        viewPeopleLinkItem : PeopleIndex -> Html msg
        viewPeopleLinkItem peopleIndex =
            Html.li []
                [ Html.a
                    [ Attr.href (Route.toHref <| Route.People__Id_ { id = peopleIndex.uid }) ]
                    [ Html.text peopleIndex.name ]
                ]
    in
    List.map viewPeopleLinkItem mockPeople
