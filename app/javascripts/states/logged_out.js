Radium.LoggedOutState = Ember.ViewState.create({
  view: Radium.LoginPane,
  enter: function(manager) {
    manager.set('isLoggedin', false);
    $.cookie('user_api_key', null);
    this._super(manager);
  }
});