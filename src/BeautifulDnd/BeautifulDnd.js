const DragDropContext = require('react-beautiful-dnd').DragDropContext
const Draggable = require('react-beautiful-dnd').Draggable
const Droppable = require('react-beautiful-dnd').Droppable


exports.dragDropContextImpl = DragDropContext;

exports.droppableImpl = ({ droppableId, isDropDisabled, renderFn }) =>
  React.createElement(Droppable, { droppableId, isDropDisabled }, renderFn)
