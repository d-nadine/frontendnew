window.ENV.environment = 'production'

Ember.Application.initializer
  name: 'adapterUrl'
  after: 'store'
  initialize: (container, application) ->
    application.set('cookieDomain', '.radiumcrm.com')

    store = container.lookup('store:main')

    Ember.assert 'store found in adapterUrl initializer', store

    store.get('_adapter').reopen
      url: window.API_HOST || 'http://api.radiumcrm.com'

Ember.Application.initializer
  name: 'stripePublicKey'
  after: 'store'
  initialize: (container, application) ->
    Stripe.setPublishableKey('pk_live_RX5MutadKEj3S5VKOYsSSncC')

Ember.onerror = (e) ->
  return if e.message == "TransitionAborted"

  Ember.Logger.error e
