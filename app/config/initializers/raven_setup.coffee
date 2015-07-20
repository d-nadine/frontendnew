Ember.Application.initializer
  name: 'raven-setup'
  initialize: (container, application) ->
    return unless window.ENV.environment == "production"

    Raven.config('https://48041647d09340b89dc618e2a2ebb6ec@app.getsentry.com/48070',
      release: '1.0.0'
      whitelistUrls: []).install()
