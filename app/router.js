import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('conversations', {path: '/conversations/:type'});

  this.route('addressbook', function(){
    this.route('people', function() {
      this.route('contacts');
      this.route('index', {path: '/filter'});
    });
    this.route('companies');
  });
});

export default Router;
