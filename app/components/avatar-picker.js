import Ember from 'ember';

const {
  Component
} = Ember;

export default Component.extend({
  actions: {
    stopEditing() {
      if(this.isDestroyed || this.isDestroying || this.get('isUploading')) {
        return undefined;
      }

      return false;
    }
  },

  isUploading: false
});