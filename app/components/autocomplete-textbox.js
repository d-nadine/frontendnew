import Ember from 'ember';

import AutocompleteMixin from "radium/mixins/autocomplete-mixin";
import AutoFillHackMixin from "radium/mixins/auto_fill_hack";
import { ValidationMixin } from "radium/mixins/validation_mixin";
import SaveModelOnKeyDown from 'radium/mixins/save_model_on_key_down';

const {
  Component
} = Ember;

export default Component.extend(AutocompleteMixin, AutoFillHackMixin, ValidationMixin, SaveModelOnKeyDown, {
  actions: {
    setBindingValue: function(object, index) {
      let value;

      if(typeof object === "string" || !object.get) {
        value = object;
      } else {
        value = object.get('person') || object;
      }

      if (this.actionOnly && value) {
        return this.sendAction('action', value);
      }

      if (this.writeableValue && this.hasOwnProperty('queryKey')) {
        this.set('value', value.get(this.queryKey));
      } else {
        this.set('value', value);
      }

      if (this.get('setindex') && value.set) {
        value.set('index', index);
      }

      this.set('backup', value);

      this.getTypeahead().hide();

      this.setValueText();

      if (!this.get('action')) {
        return null;
      }

      Ember.run.next(() => {
        this.sendAction('action', value);
      });

      return false;
    },
    showAll: function() {
      if (this.get('isAsync')) {
        return null;
      }

      if (this.get('disabled')) {
        return null;
      }

      $('.typeahead.dropdown-menu').hide();

      let typeahead;

      if (!(typeahead = this.getTypeahead())) {
        return null;
      }
      if (typeahead.shown) {
        return typeahead.hide();
      }

      const source = this.source.toArray();

      typeahead.render(source.slice(0, source.length)).show();

      return false;
    },

    removeValue: function() {
      let value, resetAction;

      if (value = this.get('value')) {
        this.set('backup', value);
      }

      if (resetAction = this.get('resetAction')) {
        this.sendAction("resetAction", resetAction);
      }

      this.set('value', null);
      this.autocompleteElement().val('').focus();
      this.send('showAll');
      this.getTypeahead().hide();

      if(!window.event) {
        return null;
      }

      window.event.stopPropagation();
      window.event.preventDefault();

      return false;
    }
  },
  backup: null,

  isAutocompleteTextBox: true,

  sync: Ember.computed.not('isAsync'),
  classNameBindings: [':autocomplete-textbox', ':field', ':combobox', ':control-box', 'isInvalid', 'isAsync', 'sync'],

  autocompleteElement: function() {
    return this.$('input[type=text].combobox:first');
  },

  input: function() {
    this._super(...arguments);

    const el = this.autocompleteElement();
    const text = el.val();

    this.query = text;

    if (this.writeableValue) {
      this.set('value', text);
    }
  },

  valueDidChange: Ember.observer('value', function() {
    return this.setValueText();
  }),

  setup: Ember.on('didInsertElement', function() {
    this._super.apply(this, arguments);
    this.setValueText();

    let value;

    if ((value = this.get('value'))) {
      this.set('backup', value);
    }

    this.autocompleteElement().off('blur');

    let typeahead = this.getTypeahead();

    $(document).on('click.autocomplete.txt.component', () => {
      let el;

      if (!(el = this.autocompleteElement())) {
        return;
      }

      const text = el.val() || '';

      if (!text.length && !this.get('dontReset')) {
        Ember.run.next(() => {
          this.reset();
        });
      }

      if ((typeahead = this.getTypeahead())) {
        if (typeahead.shown) {
          typeahead.hide();
        }
      }
    });
  }),

  autocompleteOver: Ember.on('willDestroyElement', function() {
    return $(document).off('click.autocomplete.txt.component');
  }),

  reset: function() {
    var backup;
    if (!(backup = this.get('backup'))) {
      return;
    }

    this.set('value', backup);
  },
  setValueText: function() {
    const el = this.autocompleteElement();

    const value = this.get('value');

    if (!value) {
      return el.val('');
    }

    const complete = () => {
      const displayValue = typeof value === 'string' ? value : value.get(this.queryKey);

      if (displayValue) {
        el.val(displayValue);
      }
    };

    if (value instanceof DS.Model && !value.get('isLoaded')) {
      const observer = function() {
        if (!value.get('isLoaded')) {
          return;
        }

        complete();

        value.removeObserver('isLoaded', observer);
      };

      return value.addObserver('isLoaded', observer);
    } else {
      return complete();
    }
  },
  focusIn: function(e) {
    Ember.run.next(() => {
      if (this.get('isAsync')) {
        return null;
      }

      const el = this.autocompleteElement();

      if (!el) {
        return null;
      }

      if (el.val()) {
        return this.autocompleteElement().select();
      }

      if (this.get('value')) {
        return null;
      }

      if (e.target !== el.get(0)) {
        return null;
      }
      if (!el.val().length && !this.getTypeahead().shown) {
        this.send('showAll');
      }

      e.stopPropagation();
      e.preventDefault();

      return false;
    });
  },
  keyDown: function(e) {
    if (e.keyCode !== this.ESCAPE) {
      return this._super.apply(this, arguments);
    }

    return this.reset();
  }
});
