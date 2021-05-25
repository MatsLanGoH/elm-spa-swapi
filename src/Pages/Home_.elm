module Pages.Home_ exposing (view)

import Html exposing (Html)
import Html.Attributes as Attr
import UI
import View exposing (View)


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
