window.ENV.environment = 'development'

Ember.Application.initializer
  name: 'adapterUrl'
  after: 'store'
  initialize: (container, application) ->
    store = container.lookup('store:main')

    Ember.assert 'store found in adapterUrl initializer', store

    store.get('_adapter').reopen
      url: 'http://localhost:9292'

    container.lookup('uploader:current').set 'url', "#{store.get('_adapter.url')}/uploads"

Ember.Application.initializer
  name: 'developmentCookie'
  after: 'store'
  initialize: (container, application) ->
    application.set('cookieDomain', 'development');
    Ember.$.cookie 'token', 'development'

Ember.Application.initializer
  name: 'stripePublicKey'
  after: 'store'
  initialize: (container, application) ->
    # require 'instrumentation/view_rendering'
    Stripe.setPublishableKey('pk_test_fcvBFet4q62tftqiRZntwafx')