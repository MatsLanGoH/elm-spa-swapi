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
    , page : Int
    , totalPages : Int
    }


decoder : Json.Decoder PeopleIndex
decoder =
    Utils.Json.record PeopleIndex
        |> withField "uid" Json.string
        |> withField "name" Json.string



-- |> withField "url" Json.string
-- ENDPOINTS


itemsPerPage : Int
itemsPerPage =
    25


list : { page : Int, onResponse : Data Listing -> msg } -> Cmd msg
list options =
    -- TODO: Handle pagination
    let
        queryParams =
            [ int "page" options.page
            , int "limit" itemsPerPage
            ]
    in
    Http.request
        { method = "GET"
        , headers = []
        , url = crossOrigin "https://www.swapi.tech/api" [ "people" ] queryParams
        , body = Http.emptyBody
        , expect = Api.Data.expectJson options.onResponse (paginatedDecoder options.page)
        , timeout = Just (1000 * 60)
        , tracker = Nothing
        }


paginatedDecoder : Int -> Json.Decoder Listing
paginatedDecoder page =
    let
        multiplePeople : List PeopleIndex -> Int -> Listing
        multiplePeople peopleIndices count =
            { peopleIndices = peopleIndices
            , page = page
            , totalPages = count // itemsPerPage
            }
    in
    Json.map2 multiplePeople
        (Json.field "results" (Json.list decoder))
        (Json.field "total_pages" Json.int)
