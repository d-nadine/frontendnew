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

    container.lookup('uploader:current').set 'url', "#{store.get('_adapter.url')}/uploads"

Ember.Application.initializer
  name: 'stripePublicKey'
  after: 'store'
  initialize: (container, application) ->
    Stripe.setPublishableKey('pk_live_RX5MutadKEj3S5VKOYsSSncC')

Ember.RSVP.configure 'onerror', (e) ->
  Raygun.send e

Ember.onerror = (e) ->
  Raygun.send e

Ember.Logger.error = (message, cause, stack) ->
  if typeof message == "string"
    Raygun.send(new Error(message), null, { cause: cause, stack: stack })
  else
    console.error(message)
    Raygun.send message
