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

    const bindings = spreadArgs.value.bindings || [],
          actions = spreadArgs.value.actions || [];

    bindings.forEach((binding) => {
      if(binding.static) {
        this.set(binding.name, binding.value);
      } else {
        const context = binding.context || mainContext;

        this.set(binding.name, context.get(binding.value));
      }
    });

    actions.forEach((action) => {
      const context = action.context;

      this.attrs[action.name] = context._actions[action.value].bind(action.context);
    });
  }
});
