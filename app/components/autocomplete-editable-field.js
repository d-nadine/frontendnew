import Ember from 'ember';

import EditableField from 'radium/components/editable-field';

import AutocompleteMixin from "../mixins/autocomplete-mixin";

export default EditableField.extend(AutocompleteMixin, {
  actions: {
    setBindingValue: function(object) {
      const key = this.bufferKey ? this.bufferKey : this.field;

      if (!this.get('actionOnly')) {
        if (object instanceof DS.Model) {
          this.set("bufferedProxy." + (this.get('bufferKey')), object.get(this.field));
        } else {
          this.set("bufferedProxy." + (this.get('bufferKey')), object.get(key));
        }
      } else {
        const saveAction = this.get('saveAction');

        Ember.assert("You must have a saveAction specified", saveAction);

        Ember.assert('we need to supply a containingController fix', this.get('containingController'));

        this.get('containingController').send(saveAction, object);
      }

      this.set('isEditing', false);

      this.$().blur();

      return false;
    }
  },

  classNameBindings: ['isEditing'],

  getField: function() {
    return this.get('queryKey');
  },

  bindQuery: function() {
    const  bufferKey = this.get('bufferKey');
    const bufferDep = "bufferedProxy." + bufferKey;

    return bufferDep;
  },

  autocompleteElement: function() {
    return this.$();
  },

  keyDown: function(e) {
    if (e.keyCode === this.ENTER) {
      if (!this.getTypeahead().shown) {
        const obj = {};

        obj[this.bufferKey] = this.get('bufferedProxy').get(this.bufferKey);

        obj['id'] = this.get('model.id');

        this.send('setBindingValue', Ember.Object.create(obj));
      } else {
        this._super.apply(this, arguments);
      }
    }

    if (e.keyCode !== this.ESCAPE) {
      return this._super.apply(this, arguments);
    }
    const bufferedProxy = this.get('bufferedProxy');
    const bufferKey = this.get('bufferKey');
    const original = this.get('model').get(bufferKey);

    bufferedProxy.set(bufferKey, original);

    return this.setMarkup();
  }
});
