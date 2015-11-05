import Ember from 'ember';

const {
  Mixin
} = Ember;

export default Mixin.create({
  actions: {
    selectContent() {
      const el = this.$('.editable-field-component');

      const later = Ember.run.later(() => {
        el.selectText();
        Ember.run.cancel(later);
      });
    }
  }
});