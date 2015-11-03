import Ember from 'ember';

const {
  Component
} = Ember;

export default Component.extend({
  actions: {
    linkAction: function() {
      let linkAction;
      if (!(linkAction = this.get('linkAction'))) {
        return undefined;
      }

      console.log('refactor containingController');

      return false;
    }
  },

  didInitAttrs(options) {
    this._super(...arguments);

    const spreadArgs = options.attrs.spreadArgs;

    if(!spreadArgs) {
      return;
    }

    spreadArgs.value.bindings.forEach((binding) => {
      if(!binding.static) {
        this.set(binding.name, binding.context.get(binding.value));
      } else {
        this.set(binding.name, binding.value);
      }
    });
  }
});
