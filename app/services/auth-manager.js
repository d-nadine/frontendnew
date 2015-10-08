import Ember from 'ember';

export default Ember.Service.extend({
  _token: null,

  _initialze: Ember.on('init', function() {
    this.setToken($.cookie('token'));
  }),

  setToken(token) {
    this.set('token', token);

    Ember.$.ajaxSetup({
      headers: {
        "X-Ember-Compat": "true",
        "X-User-Token": token
      }
    });
  }
});
