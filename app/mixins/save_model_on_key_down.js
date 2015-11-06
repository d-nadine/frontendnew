import Ember from 'ember';

import { ENTER } from "radium/utils/key-constants";

const {
  Mixin
} = Ember;

export default Mixin.create({
  keyDown(e) {
    this._super(...arguments);

    if(e.keyCode !== ENTER) {
      return;
    }

    if(this.get('saveModel')) {
      this.send('saveModel');
    }
  }
});