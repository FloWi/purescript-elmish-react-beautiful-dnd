module Main where

import Prelude
import Data.Traversable (for)
import DragAndDrop as DragAndDrop
import Effect (Effect)
import Effect.Aff (Aff)
import Elmish as Elmish
import Elmish.Boot as Boot
import Elmish.Component (ComponentReturnCallback)
import Frame as Frame

main :: Effect Unit
main = do
  items <-
    for examples \e -> do
      render <- e.create Elmish.construct
      pure { title: e.title, view: render }
  Boot.defaultMain { elementId: "app", def: Frame.frame items }

type Example
  = { title :: String
    , create :: forall a. ComponentReturnCallback Aff (Effect a) -> Effect a
    }

examples :: Array Example
examples =
  [ { title: "Playlist counter"
    , create: \f -> f DragAndDrop.def
    }
  ]
