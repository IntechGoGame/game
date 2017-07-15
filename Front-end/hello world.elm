import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array exposing (..)
import Http
import Json.Decode as Decode
import Debug exposing (..)


main =
  Html.program
    { init = init "cats"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { myRequest : String,
  flipCard : String
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
  | SelectCard(Int)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChooseTile ->
      (model, httpRequest model.myRequest)

    NewGif (Ok newUrl) ->
      (Model model.myRequest newUrl, Cmd.none)

    NewGif (Err _) ->
      (model, Cmd.none)

    SelectCard(index) ->

  (model, flipCardFx index model.flipCard) 


-- VIEW


view : Model -> Html Msg
view model =
 table [style [("border","2px solid black")]]
                 (cardView0)
 
cardView0 : List (Html Msg)
cardView0 = cardView1 cardList

cardView1 :  List String  -> List (Html Msg)
cardView1 = List.indexedMap(cardView2)
  
cardView2 : Int -> a -> Html Msg
cardView2 index cardList = th [onClick (SelectCard index), style [("cursor", "pointer"),("height","50px"),("width","50px")]][text "?"]
      
  
  
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- FUNCTION 

flipCardFx : Int -> String -> Cmd Msg 
flipCardFx index flipCard  = 
  let 
   indexLog = toString (index)   
   url = "http://google.com" 
 in 
    log indexLog 
    Http.send NewGif (Http.request{
  method = "GET",
 url = url,
    headers = [Http.header "Access-Control-Allow-Origin" "access-control-allow-origin"],
 body = Http.emptyBody,
    expect = Http.expectJson decodeGifUrl,
 timeout = Nothing, withCredentials = False
  })
  

  
 
 
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



