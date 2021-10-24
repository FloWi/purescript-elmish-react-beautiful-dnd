module MyComponent where

import Data.Unit (Unit)
import Effect.Uncurried (EffectFn1)
import Elmish.React (createElement)
import Elmish.React.Import (ImportedReactComponent, ImportedReactComponentConstructorWithContent)

-- ====================== DragDropContext ======================
type DragEndResult
  = { destination :: String, source :: String, draggableId :: String }

type DragDropContextProps r
  = ( onDragEnd :: EffectFn1 DragEndResult Unit | r )

type DragDropContextOptProps r
  = ( dragHandleUsageInstructions :: String | r )

dragDropContext :: ImportedReactComponentConstructorWithContent DragDropContextProps DragDropContextOptProps
dragDropContext = createElement dragDropContextImpl
foreign import dragDropContextImpl :: ImportedReactComponent

-- ====================== Droppable ======================
type DroppableProps r
  = ( droppableId :: String | r )
type DroppableOptProps r
  = ( isDropDisabled :: Boolean | r )

droppable :: ImportedReactComponentConstructorWithContent DroppableProps DroppableOptProps
droppable = createElement droppableImpl

foreign import droppableImpl :: ImportedReactComponent
