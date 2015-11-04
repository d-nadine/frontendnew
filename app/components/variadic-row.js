import Ember from 'ember';

const {
  Component,
  computed,
  run
} = Ember;

export default Component.extend({
  tagName: "tr",

  classNameBindings: ['item.isChecked:is-checked', 'item.read:read:unread'],
  attributeBindings: ['dataModel:data-model'],

  dataModel: computed.oneWay('item.id'),

  transposedColumns: computed('columns.[]', 'item', function() {
    const item = this.get('item');

    return this.get('columns').map((column) => {
      let result = {
        component: null,
        attrs: [],
        tableRow: this,
        context: item
      },
      component;

      if((component = column.component)) {
        result.component = component;
      }

      result.bindings = column.bindings.map((binding) => {
        // FIXME: how do we handle different contexts?
        // if (binding.context) ?
        //

        return binding;
      });

      return result;
    });
  }),

  model: computed.oneWay('item'),

  modelIdentifier: null,

  modelUpdated() {
    if(this.isDestroyed || this.isDestroying) {
      return;
    }

    run.scheduleOnce('render', this, 'rerender');
  },

  _initialize: Ember.on('init', function() {
    this._super(...arguments);

    if(!this.get('model.id')) {
      return;
    }

    const model = this.get('model');

    if(!model.updatedEventKey) {
      return;
    }

    this.modelIdentifier = model.updatedEventKey();

    this.EventBus.subscribe(this.modelIdentifier, this, 'modelUpdated');
  }),

  _teardown: Ember.on('willDestroyElement', function() {
    this._super(...arguments);

    if(!this.modelIdentifier) {
      return;
    }

    this.EventBus.unsubscribe(this.modelIdentifier);
  })
});
