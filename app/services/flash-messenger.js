import Ember from 'ember';

const {
  Service,
  A: emberArray
} = Ember;

export default Service.extend({
  init() {
    this._super(...arguments);

    this.queue = emberArray();
  },

  success(message) {
    this.addMessage({
      type: 'alert-success',
      message: message
    });
  },

  error(message) {
    if(message instanceof DS.Model) {
      var name,
          errors = message.get('errors'),
          err,
          results = emberArray();

      for(name in errors) {
        err = errors[name];

        results.push(`${name}: ${err}`);
      }

      this.addMessage({
        type: 'alert-error',
        errors: results
      });
    }

    this.addMessage({
      type: 'alert-error',
      message: message
    });
  },

  addMessage(message) {
    this.queue.pushObject(message);
  },

  removeMessage(message) {
    if(!this.queue.contains(message)) {
      return;
    }

    this.queue.removeObject(message);
  }
});
