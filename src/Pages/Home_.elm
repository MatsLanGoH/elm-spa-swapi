module Pages.Home_ exposing (page)

import Html exposing (Html)
import Html.Attributes as Attr
import Page exposing (Page)
import Request exposing (Request)
import Shared
import UI
import View exposing (View)


page : Shared.Model -> Request -> Page
page _ _ =
    Page.static
        { view = view }


view : View msg
view =
    { title = "Homepage"
    , body = UI.layout viewBody
    }


viewBody : List (Html msg)
viewBody =
    [ Html.h1 [] [ Html.text "SWAPI Test Page" ]
    , Html.div []
        [ Html.p []
            [ Html.text "This is a test page to play around with JSON data retrieval using the "
            , Html.a [ Attr.href "https://www.swapi.tech" ] [ Html.text "Star Wars API" ]
            , Html.text "."
            ]
        ]
    ]
