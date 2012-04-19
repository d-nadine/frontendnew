Radium.LoggedOutState = Ember.ViewState.create({
  view: Radium.LoginPane,
  enter: function(manager) {
    $.cookie('user_api_key', null, {path: '/', domain: '.radiumcrm.com'});
    manager.set('isLoggedin', false);
    this._super(manager);
  }
});