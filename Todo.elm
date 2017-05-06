module Todo exposing (..)

import Html as H
import Html.Attributes as HA
import Html.Events as HE

type Msg 
  = Toggle Int

type alias Model = 
  { completed : Bool
  , title     : String 
  , todoId    : Int
  }

newTodo : Bool -> String -> Int -> Model
newTodo c t i = { completed = c , title = t, todoId = i }

view : Model -> H.Html Msg
view model = H.li [HA.classList [("completed",model.completed)]] 
  [ H.label []
    [ H.input 
      [ HA.type_ "checkbox"
      , HA.class "toggle"
      , HE.onClick (Toggle model.todoId) 
      , HA.checked model.completed
      ] []
    , H.text model.title ]
  ]

update : Msg -> Model -> Model
update msg model =
  case msg of
    Toggle toggleId -> { model | completed = not model.completed}