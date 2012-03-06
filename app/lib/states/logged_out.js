Radium.LoggedOutState = Ember.ViewState.create({
  view: Radium.LoginPane,
  enter: function(manager) {
    manager.set('isLoggedin', false);
    this._super(manager);
  }
});