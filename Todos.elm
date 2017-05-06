module Todos exposing (..)

import Html as H
import Html.Keyed as HK
import Html.Attributes as HA
import Html.Events as HE
import Platform.Cmd exposing (Cmd)
import Platform.Sub exposing (Sub)
import Json.Decode as Json
import Todo

type Msg 
  = TodoMsg Int Todo.Msg
  | UpdateString String
  | NewTodo

type alias Model = 
  { todos      : List Todo.Model
  , editingStr : String
  , nextId     : Int
  }

init : Model
init = 
  { editingStr = ""
  , nextId = 3
  , todos = 
    [ { completed = False , title = "Write Talk", todoId = 2 }
    , { completed = True  , title = "Propose Talk", todoId = 1 }
    ]}

todoKeyedView : Todo.Model -> (String, H.Html Msg)
todoKeyedView todo = 
  (toString todo.todoId ,H.map (TodoMsg todo.todoId) <| Todo.view todo)

view : Model -> H.Html Msg
view model = H.section [] 
  [H.section [HA.class "todo"]
    [ H.input 
      [ HA.class "new-todo"
      , HA.placeholder "What needs to be done?" 
      , HA.autofocus True
      , HA.name "newTodo" 
      , HA.value model.editingStr
      , HE.onInput UpdateString
      , onEnter NewTodo
      ] 
      []
    , HK.ul [HA.class "todo-list"] <| List.map todoKeyedView model.todos 
    ]]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    TodoMsg i m -> 
      ( { model 
      | todos = List.map (\t -> if t.todoId == i then Todo.update m t else t) model.todos } 
      , Cmd.none )
    UpdateString s ->
      ( { model | editingStr = s }, Cmd.none )
    NewTodo ->
      ( { model 
        | editingStr = ""
        , nextId = model.nextId + 1
        , todos = 
          [{completed = False, title = model.editingStr, todoId = model.nextId}] ++
          model.todos
        }, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

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