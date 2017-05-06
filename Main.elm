import Html as H
import Html.Keyed as HK
import Html.Attributes as HA
import Html.Events as HE
import Platform.Cmd exposing (Cmd)
import Platform.Sub exposing (Sub)
import Json.Decode as Json
import Todos
import Pomodoro

type Msg 
  = PomodoroMsg Pomodoro.Msg
  | TodosMsg Todos.Msg

type alias Model = 
  { todos      : Todos.Model
  , pomodoro   : Pomodoro.Model
  }

init : Model
init = 
  { todos    = Todos.init
  , pomodoro = Pomodoro.init
  }

view : Model -> H.Html Msg
view model = H.section [] 
  [ H.map PomodoroMsg <| Pomodoro.view model.pomodoro 
  , H.map TodosMsg <| Todos.view model.todos 
  ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    PomodoroMsg m -> 
      let (newP,cmd) = Pomodoro.update m model.pomodoro 
      in ( { model | pomodoro = newP }, Cmd.map PomodoroMsg cmd )
    TodosMsg m -> 
      let (newT,cmd) = Todos.update m model.todos 
      in ( { model | todos = newT }, Cmd.map TodosMsg cmd )

subscriptions : Model -> Sub Msg
subscriptions model = Sub.map PomodoroMsg <| Pomodoro.subscriptions model.pomodoro

main : Program Never Model Msg
main =
  H.program
    { init = (init, Cmd.none)
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

onEnter : Msg -> H.Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg
            else
                Json.fail "not ENTER"
    in
        HE.on "keydown" (Json.andThen isEnter HE.keyCode)