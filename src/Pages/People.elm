module Pages.People exposing (page)

import Gen.Params.People exposing (Params)
import Html exposing (Html)
import Page exposing (Page)
import Request
import Shared
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page
page shared req =
    Page.static
        { view = view
        }


view : View msg
view =
    { title = "People"
    , body = UI.layout viewBody
    }


viewBody : List (Html msg)
viewBody =
    [ Html.h1 [] [ Html.text "People" ]
    , Html.div []
        [ Html.p []
            [ Html.text "People will go here" ]
        ]
    ]
