import Ember from 'ember';

const {
  Service
} = Ember;

export default Service.extend(Ember.Evented, {
  publish: function() {
    return this.trigger.apply(this, arguments);
  },

  subscribe: function() {
    return this.on.apply(this, arguments);
  },

  unsubscribe: function() {
    return this.off.apply(this, arguments);
  },

  publishModelUpdate: function(model) {
    if (!model) {
      return undefined;
    }

    return this.publish(model.updatedEventKey(), model);
  }
});
