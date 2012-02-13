Radium.LoggedOutState = Ember.ViewState.create({
  view: Radium.LoginPane,
  enter: function(manager) {
    manager.set('isLoggedin', NO);
    this._super(manager);
  }
});