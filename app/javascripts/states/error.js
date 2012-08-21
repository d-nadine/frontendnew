Radium.ErrorTypes = Ember.Object.create({
  errorString: null,
  keys: {
    401: "Unauthorized. Authentication failed.",
    403: "You don't have access to that",
    404: "Looks like you still haven't found what you're looking for.",
    412: "There is not enough money in your account.",
    422: "Check your entry for errors.",
    500: "Server did something wrong. We're sorry.",
    all: "Unknown problem, please report."
  },
  setKey: function(error) {
    if (this.keys[error]) {
      this.set('errorString', this.keys[error]);
    } else {
      this.set('errorString', this.keys.all);
    }
  }
});

Radium.ErrorBanner = Ember.View.extend({
  classNames: ['global-error'],
  errorStringBinding: 'Radium.ErrorTypes.errorString',
  template: Ember.Handlebars.compile('<div class="alert alert-error">{{errorString}} <button class="close" {{action "closeError" target="Radium.ErrorManager"}}>&times;</button></div>')
});

Radium.ErrorManager = Ember.StateManager.create({
  enableLogging: true,
  initialState: 'noErrors',

  noErrors: Ember.State.create({
    errorLogger: function(error) {
      var errorLog = '[%@] Unexpected Response: %@\n%@'.fmt(
            Ember.DateTime.create().toFormattedString('%d-%m %H:%M:%S'),
            error.status,
            error.responseText
          );
      console.error(errorLog);
    },
    displayError: function(manager, context) {
      this.errorLogger(context);
      Radium.ErrorTypes.setKey(context.status);
      manager.goToState('error');
    }
  }),

  error: Ember.ViewState.create({
    view: Radium.ErrorBanner,
    exit: function(manager) {
      Radium.ErrorTypes.set('errorString', null);
      this._super(manager);
    },
    closeError: function(manager, event) {
      event.preventDefault();
      manager.goToState('noErrors');
    }
  })
});
