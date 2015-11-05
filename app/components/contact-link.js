import Ember from 'ember';
import SpreadArgs from 'radium/mixins/spread-args-mixin';
import ContainingParent from 'radium/mixins/containing-parent-mixin';

const {
  Component
} = Ember;

export default Component.extend(SpreadArgs, ContainingParent, {
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
