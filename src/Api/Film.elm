module Api.Film exposing (Film, Listing, get, list)

import Api.Data exposing (Data)
import Http
import Json.Decode as Json
import Utils.Json exposing (withField)


type alias Film =
    { properties : FilmProperties
    , uid : String
    }


type alias FilmProperties =
    { title : String
    , episodeId : Int
    , openingCrawl : String
    , director : String
    , producer : String
    , release_date : String
    , url : String
    }


type alias Listing =
    { films : List Film }


decoder : Json.Decoder Film
decoder =
    Utils.Json.record Film
        |> withField "properties" filmPropertiesDecoder
        |> withField "uid" Json.string


filmPropertiesDecoder : Json.Decoder FilmProperties
filmPropertiesDecoder =
    Utils.Json.record FilmProperties
        |> withField "title" Json.string
        |> withField "episode_id" Json.int
        |> withField "opening_crawl" Json.string
        |> withField "director" Json.string
        |> withField "producer" Json.string
        |> withField "release_date" Json.string
        |> withField "url" Json.string


listDecoder : Json.Decoder Listing
listDecoder =
    Json.map Listing
        (Json.field "result" (Json.list decoder))



-- ENDPOINTS


list : { onResponse : Data Listing -> msg } -> Cmd msg
list options =
    Http.request
        { method = "GET"
        , headers = []
        , url = "https://www.swapi.tech/api/films/"
        , body = Http.emptyBody
        , expect = Api.Data.expectJson options.onResponse listDecoder
        , timeout = Just (1000 * 60)
        , tracker = Nothing
        }


get : { uid : String, onResponse : Data Film -> msg } -> Cmd msg
get options =
    Http.request
        { method = "GET"
        , headers = []
        , url = "https://www.swapi.tech/api/films/" ++ options.uid ++ "/"
        , body = Http.emptyBody
        , expect = Api.Data.expectJson options.onResponse (Json.field "result" decoder)
        , timeout = Just (1000 * 60)
        , tracker = Nothing
        }
