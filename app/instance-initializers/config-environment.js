import Ember from 'ember';
import ENV from 'radium/config/environment';
import "radium/utils/date-time";
import "radium/extensions/extensions";

export function initialize(instance) {
  instance.set('cookieDomain', ENV.cookieDomain);

  if(ENV.cookieDomain === "development") {
    Ember.$.cookie('token', 'development');
  }

  const store = instance.container.lookup('store:main');

  store.get('_adapter').reopen({
    url: ENV.apiHost
  });
}

export default {
  name: 'config-environment',
  initialize: initialize,
  after: 'store'
};
