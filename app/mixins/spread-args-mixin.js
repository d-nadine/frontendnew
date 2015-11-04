import Ember from 'ember';

const {
  Mixin
} = Ember;

export default Mixin.create({
  didInitAttrs(options) {
    this._super(...arguments);

    const spreadArgs = options.attrs.spreadArgs;

    if(!spreadArgs) {
      return;
    }

    const mainContext = spreadArgs.value.context;

    spreadArgs.value.bindings.forEach((binding) => {
      if(binding.static) {
        this.set(binding.name, binding.value);
      } else {
        const context = binding.context || mainContext;

        this.set(binding.name, context.get(binding.value));
      }
    });
  }
});
