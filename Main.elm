import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Platform.Cmd exposing (Cmd)
import Platform.Sub exposing (Sub)

type Msg = Noop

type alias Todo = 
  { completed : Bool
  , title     : String 
  }

type alias Model = 
  { todos : List Todo }

init : Model
init = { todos = 
  [ { completed = False , title = "Write Talk" }
  , { completed = True  , title = "Propose Talk" }
  ]}

view : Model -> H.Html Msg
view model = H.body [] []

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Noop -> ( model, Cmd.none )

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