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
   name : String,
   index : Int,
   isVisible : Bool   
 }
  
createCard0 : Card 
createCard0 = Card "-1" -1 False
{-  
createCard1 : String -> Int -> Bool -> Card
createCard1 name index isVisible = Card(name index isVisible)
  -}
cardListTest : List Card
cardListTest = [ Card "a" 1 False, Card "b" 2 False,  Card "c" 3 False, Card "d" 4 False,  Card "e" 5 False, Card "f" 6 False, 
 Card "a" 7 False, Card "b" 8 False,  Card "c" 9 False, Card "d" 10 False,  Card "e" 11 False, Card "f" 12 False ]
 
cardList : Array String
cardList =  Array.fromList[ "a", "b", "c", "d", "e", "f","a", "b", "c", "d", "e", "f" ]

-- UPDATE


type Msg
  = ChooseTile
  | NewGif (Result Http.Error String)
  | SelectCard(Int)
{-  | UpdateCardList -}

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
    
    {- UpdateCardList -> (model, updateCardListFx0)  -}

-- VIEW


view : Model -> Html Msg
view model =
 table [style [("border","2px solid black")]]
                 (defaultCardView0)
 
defaultCardView0 : List (Html Msg)
defaultCardView0 = defaultCardView1 cardListTest

defaultCardView1 :  List Card  -> List (Html Msg)
defaultCardView1 = List.indexedMap(defaultCardView2)
  
defaultCardView2 : Int -> a -> Html Msg
defaultCardView2 index cardListTest = th [onClick (SelectCard index), style [("cursor", "pointer"),("height","50px"),("width","50px")]][text (defaultCardContent index)]

defaultCardContent : Int -> String
defaultCardContent index = toString (List.head(List.drop index cardListTest))

cardView0 : List (Html Msg)
cardView0 = cardView1 cardListTest

cardView1 :  List Card  -> List (Html Msg)
cardView1 = List.indexedMap(cardView2)
  
cardView2 : Int -> a -> Html Msg
cardView2 index cardListTest = th [onClick (SelectCard index), style [("cursor", "pointer"),("height","50px"),("width","50px")]][text (cardContent index)]

cardContent : Int -> String
cardContent index = if (getIsVisible(getCardFromMaybe((List.head(List.drop index cardListTest)))) ==  True) then toString (Array.get index cardList) else "?"

getCardFromMaybe : Maybe Card -> Card
getCardFromMaybe card = case card of
    Nothing -> createCard0
    Just card -> card

getIsVisible : Card -> Bool
getIsVisible card = card.isVisible
  
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- FUNCTION 

flipCardFx : Int -> String -> Cmd Msg 
flipCardFx index flipCard  = 
  let 
   indexLog = toString (Array.get index cardList )   
   cardContentLog = cardContent index
   url = "http://google.com" 
 in 
    log indexLog 
    log cardContentLog
  {-  updateCardListFx0 cardListTest index
-}
    Http.send NewGif (Http.request{
  method = "GET",
 url = url,
    headers = [Http.header "Access-Control-Allow-Origin" "access-control-allow-origin"],
 body = Http.emptyBody,
    expect = Http.expectJson decodeGifUrl,
 timeout = Nothing, withCredentials = False
  })

{-
updateCardListFx0 : Cmd Msg  
updateCardListFx0 = updateCardListFx1
  
updateCardListFx1 : Int -> Cmd Msg
updateCardListFx1 index = updateCardListFx2 cardListTest index
  
updateCardListFx2 : List Card -> Int -> Cmd Msg
updateCardListFx2 cardListTest index = List.map (\x -> ( if(x.index == index ) then x else x))  cardListTest 
    -}
 
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



