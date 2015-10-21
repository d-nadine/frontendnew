import Ember from 'ember';

const {
  Service
} = Ember;

export default Service.extend({
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
  },

  logOut() {
    const apiUrl = `${this.container.lookup('store:main').get('_adapter.url')}/sessions/destroy`;

    Ember.$.ajax({
      url: apiUrl,
      dataType: 'jsonp',
      success: function() {
        return window.location.replace('http://www.radiumcrm.com/');
      }
    });
  }
});
