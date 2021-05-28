module Pages.People.Id_ exposing (page)

import Html exposing (Html)
import Page exposing (Page)
import Request exposing (Request)
import Shared
import UI
import View exposing (View)


type alias Params =
    { id : String
    }


page : Shared.Model -> Request.With Params -> Page
page _ req =
    Page.static
        { view = view req.params }


view : Params -> View msg
view params =
    { title = "People Detail " ++ params.id
    , body = UI.layout <| viewBody params
    }


viewBody : Params -> List (Html msg)
viewBody params =
    [ Html.h1 [] [ Html.text ("People detail: " ++ params.id) ]
    , Html.div []
        [ Html.p []
            [ Html.text "People details will go here" ]
        ]
    ]
