import Ember from 'ember';
import Resolver from 'ember/resolver';
import loadInitializers from 'ember/load-initializers';
import config from './config/environment';

Ember.MODEL_FACTORY_INJECTIONS = true;

FastClick.attach(document.body);

const App = Ember.Application.extend({
  modulePrefix: config.modulePrefix,
  podModulePrefix: config.podModulePrefix,
  Resolver: Resolver
});

document.addEventListener('click', function() {
  if(!window.Intercom) {
    return;
  }

  window.Intercom("update", {
    increments: {
      number_of_clicks: 1
    }
  });

  window.Intercom('reattach_activator');
}, false);



loadInitializers(App, config.modulePrefix);

$.cloudinary.config({ cloud_name: 'radium', api_key: '472523686765267'});

export default App;
