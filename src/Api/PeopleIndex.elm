module Api.PeopleIndex exposing (Listing, PeopleIndex, list)

import Api.Data exposing (Data)
import Http
import Json.Decode as Json
import Url.Builder exposing (crossOrigin, int, string)
import Utils.Json exposing (withField)


type alias PeopleIndex =
    { uid : String
    , name : String

    -- , url : String
    }


type alias Listing =
    { peopleIndices : List PeopleIndex
    }


decoder : Json.Decoder PeopleIndex
decoder =
    Utils.Json.record PeopleIndex
        |> withField "uid" Json.string
        |> withField "name" Json.string



-- |> withField "url" Json.string
-- ENDPOINTS


list : { page : Maybe String, onResponse : Data Listing -> msg } -> Cmd msg
list options =
    -- TODO: Handle pagination
    let
        queryParams =
            case options.page of
                Just page ->
                    [ string "page" page
                    , int "limit" 10
                    ]

                Nothing ->
                    []
    in
    Http.request
        { method = "GET"
        , headers = []
        , url = crossOrigin "https://www.swapi.tech/api" [ "people" ] queryParams
        , body = Http.emptyBody
        , expect = Api.Data.expectJson options.onResponse paginatedDecoder
        , timeout = Just (1000 * 60)
        , tracker = Nothing
        }


paginatedDecoder : Json.Decoder Listing
paginatedDecoder =
    Json.map Listing
        (Json.field "results" (Json.list decoder))
