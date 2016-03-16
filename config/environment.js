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
      'script-src': "'self' 'unsafe-inline' https://maps.googleapis.com https://cdn.raygun.io intercom.io https://js.intercomcdn.com https://widget.intercom.io http://localhost:9292",
      'font-src': "'self' http://fonts.gstatic.com http://maxcdn.bootstrapcdn.com",
      'connect-src': "'self' http://localhost:9292 http://api.radiumcrm.com",
      'img-src': "'self'  http://res.cloudinary.com",
      'style-src': "'self' 'unsafe-inline' http://maxcdn.bootstrapcdn.com http://fonts.googleapis.com",
      'media-src': "'self'"
    }
  };

  if (environment === 'development') {
    ENV.apiHost = 'http://localhost:9292';
    ENV.cookieDomain = 'development';
    ENV.intercom = {
      appId: "31e29cpv"
    };

    ENV['ember-cli-mirage'] = {
      enabled: false
    };
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    ENV['ember-cli-mirage'] = {
      enabled: true
    };
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';
    ENV.cookieDomain = 'test';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  if (environment === 'staging') {
    ENV.apiHost = 'http://45.55.51.62/api';
    ENV.cookieDomain = '.radiumcrm.com';
    ENV.intercom = {
      appId: "FU8fdyfydyf9823u2j3f"
    };
  }

  if (environment === 'production') {
    ENV.apiHost = 'http://api.radiumcrm.com';
    ENV.cookieDomain = '.radiumcrm.com';
    ENV.intercom = {
      appId: "d5bd1654e902b81ba0f4161ea5b45bb597bfefdf"
    };
  }

  return ENV;
};
