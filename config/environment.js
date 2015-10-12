/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'radium',
    environment: environment,
    baseURL: '/',
    locationType: 'auto',
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    },
    contentSecurityPolicy: {
      'default-src': "'none'",
      'script-src': "'self' 'unsafe-inline' https://maps.googleapis.com https://cdn.raygun.io https://widget.intercom.io",
      'font-src': "'self' https://maxcdn.bootstrapcdn.com http://fonts.googleapis.com",
      'connect-src': "'self' http://localhost:9292 http://api.radiumcrm.com",
      'img-src': "'self'  http://res.cloudinary.com",
      'style-src': "'self' 'unsafe-inline'",
      'media-src': "'self'"
    }
  };

  if (environment === 'development') {
    ENV.apiHost = 'http://localhost:9292';
    ENV.cookieDomain = 'development';
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';
    ENV.cookieDomain = 'test';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  if (environment === 'production') {
    ENV.apiHost = 'http://api.radiumcrm.com';
    ENV.cookieDomain = '.radiumcrm.com';
  }

  return ENV;
};
