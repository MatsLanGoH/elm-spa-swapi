module Api.PeopleIndex exposing (Listing, PeopleIndex, list)

import Api.Data exposing (Data)
import Http
import Json.Decode as Json
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


list : { onResponse : Data Listing -> msg } -> Cmd msg
list options =
    -- TODO: Refactor
    -- TODO: Handle pagination
    -- TODO: Handle item count
    Http.request
        { method = "GET"
        , headers = []
        , url = "https://www.swapi.tech/api/people/"
        , body = Http.emptyBody
        , expect = Api.Data.expectJson options.onResponse paginatedDecoder
        , timeout = Just (1000 * 60)
        , tracker = Nothing
        }


paginatedDecoder : Json.Decoder Listing
paginatedDecoder =
    Json.map Listing
        (Json.field "results" (Json.list decoder))
