module MyComponent where

import Data.Argonaut.Core (Json)
import Data.Unit (Unit)
import Effect.Uncurried (EffectFn1)
import Elmish (ReactElement)
import Elmish.React (createElement)
import Elmish.React.Import (ImportedReactComponent, ImportedReactComponentConstructorWithContent, ImportedReactComponentConstructor')
import Unsafe.Coerce (unsafeCoerce)

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
type DroppableProvided
  = { droppableProps :: String, innerRef :: String }
type DroppableStateSnapshot
  = { isDraggingOver :: Boolean }
type DroppableRenderFn
  = { provided :: DroppableProvided, snapshot :: DroppableStateSnapshot } -> ReactElement

type DroppableProps r
  = ( droppableId :: String, renderFn :: DroppableRenderFn | r )
type DroppableOptProps r
  = ( isDropDisabled :: Boolean | r )

-- createElement :: forall props content
--     . ValidReactProps props
--    => ReactChildren content
--    => ReactComponent props
--    -> props                        -- Props
--    -> content                      -- Children
--    -> ReactElement
droppable :: ImportedReactComponentConstructor' DroppableProps DroppableOptProps (DroppableRenderFn -> ReactElement)
droppable props childrenFn = createElement droppableImpl props (unsafeCoerce childrenFn)

foreign import droppableImpl :: ImportedReactComponent
