import Ember from 'ember';

import {
  TAB,
  ENTER,
  ESCAPE,
  DELETE,
  SPACE,
  ARROW_DOWN,
  ARROW_UP,
  ARROW_LEFT,
  ARROW_RIGHT,
  OPEN_CURLY_BRACE
}
from "radium/utils/key-constants";

const {
  Mixin
} = Ember;

export default Mixin.create({
  TAB: TAB,
  ENTER: ENTER,
  ESCAPE: ESCAPE,
  DELETE: DELETE,
  SPACE: SPACE,
  ARROW_DOWN: ARROW_DOWN,
  ARROW_UP: ARROW_UP,
  ARROW_LEFT: ARROW_LEFT,
  ARROW_RIGHT: ARROW_RIGHT,
  OPEN_CURLY_BRACE: OPEN_CURLY_BRACE
});
