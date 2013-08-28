Ember.Application.initializer
  name: 'adapterUrl'
  after: 'store'
  initialize: (container, application) ->
    store = container.lookup('store:main')

    Ember.assert 'store found in adapterUrl initializer', store

    store.get('_adapter').reopen
      url: 'http://api.radiumcrm.com'

Ember.Application.initializer
  name: 'stripePublicKey'
  after: 'store'
  initialize: (container, application) ->
    Stripe.setPublishableKey('pk_live_RX5MutadKEj3S5VKOYsSSncC')
