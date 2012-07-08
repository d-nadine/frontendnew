Radium.State = Ember.State.extend({
  enter: function(manager, transition) {
    this._super(manager, transition);

    rootView = manager.get('rootView');

    rootView.get('childViews').removeObject(rootView.get('loading'));
  }
});
