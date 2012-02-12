Radium.App.LoggedOutState = Ember.ViewState.create({
  view: loginPane,
  enter: function(manager) {
    manager.set('isLoggedin', NO);
    this._super(manager);
  }
});