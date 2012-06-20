Radium.EditTextField = Ember.TextField.extend({
  change: function() {
    this._super();
    if (this.get('value')) {
      Radium.store.commit();
    }
  }
});