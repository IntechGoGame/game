import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Debug


main =
  Html.program
    { init = init "cats"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { myRequest : String
  , gifUrl : String
  }


init : String -> (Model, Cmd Msg)
init myRequest =
  ( Model myRequest "waiting.gif"
  , httpRequest myRequest
  )

type CardName  = String
  
type alias Card =
 { 
   name : CardName   
 }

cardList : List String
cardList =
    [ "a", "b", "c", "d", "e", "f","a", "b", "c", "d", "e", "f" ]

-- UPDATE


type Msg
  = ChooseTile
  | NewGif (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChooseTile ->
      (model, httpRequest model.myRequest)

    NewGif (Ok newUrl) ->
      (Model model.myRequest newUrl, Cmd.none)

    NewGif (Err _) ->
      (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =

 table [style [("border","2px solid black")]]
  (List.map (\l ->  th [onClick ChooseTile, style [("cursor", "pointer"),("height","50px"),("width","50px")]][text l]
      ) cardList)
  


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


httpRequest : String -> Cmd Msg
httpRequest myRequest =
  let
    url =
      "https://wikipedia.org"

 in
    Http.send NewGif (Http.request{
 method = "GET",
 url = url,
    headers = [Http.header "Access-Control-Allow-Origin" "access-control-allow-origin"],
 body = Http.emptyBody,
    expect = Http.expectJson decodeGifUrl,
 timeout = Nothing, withCredentials = False
  })


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
  Decode.at ["data", "image_url"] Decode.string



