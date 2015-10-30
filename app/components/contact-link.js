import Ember from 'ember';

const {
  Component
} = Ember;

export default Component.extend({
  actions: {
    linkAction: function(contact) {
      let linkAction;
      if (!(linkAction = this.get('linkAction'))) {
        return undefined;
      }

      console.log('refactor containingController');

      return false;
    }
  }
});
