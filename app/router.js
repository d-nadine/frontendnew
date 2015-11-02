import Ember from 'ember';
import config from './config/environment';

const {
  Router: EmberRouter
} = Ember;

var Router = EmberRouter.extend({
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

  this.route('contact', {
    path: '/contacts/:contact_id'
  });
});

export default Router;
