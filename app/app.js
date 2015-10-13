import Ember from 'ember';
import Resolver from 'ember/resolver';
import loadInitializers from 'ember/load-initializers';
import config from './config/environment';

Ember.MODEL_FACTORY_INJECTIONS = true;

FastClick.attach(document.body);

let Radium = Ember.Application.extend({
  modulePrefix: config.modulePrefix,
  podModulePrefix: config.podModulePrefix,
  Resolver: Resolver
});

document.addEventListener('click', function() {
  window.Intercom("update", {
    increments: {
      number_of_clicks: 1
    }
  });
  return window.Intercom('reattach_activator');
}, false);



loadInitializers(Radium, config.modulePrefix);

export default Radium;
