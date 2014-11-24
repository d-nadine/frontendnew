Ember.Application.initializer
  name: 'adapterUrl'
  after: 'store'
  initialize: (container, application) ->
    application.set('cookieDomain', '.radiumcrm.com')

    store = container.lookup('store:main')

    Ember.assert 'store found in adapterUrl initializer', store

    console.log("production.coffee", window.API_HOST)
    store.get('_adapter').reopen
      url: window.API_HOST || 'http://api.radiumcrm.com'

Ember.Application.initializer
  name: 'stripePublicKey'
  after: 'store'
  initialize: (container, application) ->
    Stripe.setPublishableKey('pk_live_RX5MutadKEj3S5VKOYsSSncC')

# FIXME: we should be reporting these errors
# using honeybadger or something?
Ember.onerror = (e) ->
  return if e.message == "TransitionAborted"

  console.log e.message
  console.log e.stack
