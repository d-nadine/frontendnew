import Ember from 'ember';
import SpreadArgs from 'radium/mixins/spread-args-mixin';

const {
  Component
} = Ember;

export default Component.extend(SpreadArgs, {
  actions: {
    linkAction: function(contact) {
      let linkAction;

      if (!(linkAction = this.get('linkAction'))) {
        return undefined;
      }

      return this.attrs.linkAction(contact);
    }
  }
});
