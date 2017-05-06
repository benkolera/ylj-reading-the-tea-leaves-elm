import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Platform.Cmd exposing (Cmd)
import Platform.Sub exposing (Sub)

type Msg = Toggle Int

type alias Todo = 
  { completed : Bool
  , title     : String 
  , todoId    : Int
  }

type alias Model = 
  { todos : List Todo }

init : Model
init = { todos = 
  [ { completed = False , title = "Write Talk", todoId = 2 }
  , { completed = True  , title = "Propose Talk", todoId = 1 }
  ]}

todoView : Todo -> H.Html Msg
todoView t = H.li [HA.classList [("completed",t.completed)]] 
  [ H.label []
    [ H.input 
      [ HA.type_ "checkbox"
      , HA.class "toggle"
      , HE.onClick (Toggle t.todoId) 
      ] []
    , H.text t.title ]
  ]

view : Model -> H.Html Msg
view model = H.body [] 
  [H.section [HA.class "todo"]
    [H.ul [HA.class "todo-list"] 
      <| List.map todoView model.todos 
      ]]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Toggle toggleId -> 
      ( { model 
        | todos = List.map 
          (\t -> if t.todoId == toggleId 
                 then { t | completed = not t.completed } 
                 else t 
          ) model.todos 
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