module Pomodoro exposing (..)

import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Platform.Cmd exposing (Cmd)
import Platform.Sub exposing (Sub)
import Maybe.Extra as MaybeExtra

type Msg = Noop

type alias Timer = 
  { millisLeft  : Int
  , minutesLeft : Int 
  , secondsLeft : Int
  } 

type alias Model =
  { timer : Maybe Timer }

init : Model
init = { timer = Just 
  { millisLeft = 25 * 60000
  , minutesLeft = 25
  , secondsLeft = 0
  }}

view : Model -> H.Html Msg
view model = H.section [HA.class "pomodoro"]
  [ MaybeExtra.unwrap timerSelectorView timerView model.timer ]

timerSelectorView : H.Html Msg
timerSelectorView = H.section [HA.class "timer-selector"] 
  [ H.text "Select a task from below to start a timer..." 
  ]

timerView : Timer -> H.Html Msg
timerView timer = H.section [HA.class "timer"] 
  [ H.span [HA.class "timer-minutes"] [H.text (String.padLeft 2 '0' <| toString timer.minutesLeft)] 
  , H.span [HA.class "timer-colon"] [H.text ":"]
  , H.span [HA.class "timer-seconds"] [H.text (String.padLeft 2 '0' <| toString timer.secondsLeft)] 
  ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    Noop -> ( model, Cmd.none )