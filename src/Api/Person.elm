module Api.Person exposing (..)

import Api.Data exposing (Data)
import Http
import Json.Decode as Json
import Utils.Json exposing (withField)


type alias Person =
    { name : String
    , birthYear : String
    , skinColor : String
    , eyeColor : String
    , height : String
    , mass : String
    , gender : String

    -- , homeworld: String
    -- , url: String
    }


decoder : Json.Decoder Person
decoder =
    Utils.Json.record Person
        |> withField "name" Json.string
        |> withField "birth_year" Json.string
        |> withField "skin_color" Json.string
        |> withField "eye_color" Json.string
        |> withField "height" Json.string
        |> withField "mass" Json.string
        |> withField "gender" Json.string



-- ENDPOINTS


get : { id : String, onResponse : Data Person -> msg } -> Cmd msg
get options =
    Http.request
        { method = "GET"
        , headers = []
        , url = "https://www.swapi.tech/api/people/" ++ options.id ++ "/"
        , body = Http.emptyBody
        , expect = Api.Data.expectJson options.onResponse (Json.field "result" (Json.field "properties" decoder))
        , timeout = Just (1000 * 60)
        , tracker = Nothing
        }
