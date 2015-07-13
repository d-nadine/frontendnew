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

Ember.onerror = (e) ->
  return if e.message == "TransitionAborted"

  Ember.Logger.error e

Ember.Application.initializer
  name: 'raven-setup'
  initialize: (container, application) ->
    Raven.config('https://48041647d09340b89dc618e2a2ebb6ec@app.getsentry.com/48070',
      release: '1.0.0'
      whitelistUrls: []).install()
