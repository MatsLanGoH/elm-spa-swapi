module Api.PeopleIndex exposing (PeopleIndex)

import Effect exposing (Effect)
import Json.Decode as Json
import Utils.Json exposing (withField)


type alias PeopleIndex =
    { uid : String
    , name : String

    -- , url : String
    }


decoder : Json.Decoder PeopleIndex
decoder =
    Utils.Json.record PeopleIndex
        |> withField "uid" Json.string
        |> withField "name" Json.string



-- |> withField "url" Json.string


type alias Listing =
    { peopleIndices : List PeopleIndex
    }


paginatedDecoder : Json.Decoder Listing
paginatedDecoder =
    Json.map Listing
        (Json.field "results" (Json.list decoder))
