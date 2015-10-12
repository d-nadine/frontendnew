import Ember from 'ember';
import ENV from 'radium/config/environment';

export function initialize(container, application) {
  application.set('cookieDomain', ENV.cookieDomain);

  if(ENV.cookieDomain === "development") {
    Ember.$.cookie('token', 'development');
  }

  const store = container.lookup('store:main');

  store.get('_adapter').reopen({
    url: ENV.apiHost
  });
}

export default {
  name: 'config-environment',
  initialize: initialize,
  before: 'auth',
  after: 'store'
};
