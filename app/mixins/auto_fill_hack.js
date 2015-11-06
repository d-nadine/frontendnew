import Ember from 'ember';

const {
  Mixin
} = Ember;

export default Mixin.create({
  autoFillHack: Ember.on('didInsertElement', function() {
    const el = this.autocompleteElement();

    Ember.run.next(() => {
      el.get(0).removeAttribute('disabled');
    });
  })
});
