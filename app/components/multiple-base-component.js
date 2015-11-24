import Ember from 'ember';

import FormArrayBehaviour from 'radium/mixins/form-array-behaviour';
import InlineEditorBehviour from 'radium/mixins/inline-editor-behaviour';

const {
  Component
} = Ember;

export default Component.extend(FormArrayBehaviour, InlineEditorBehviour, {
  actions: {
    toggleEditor: function() {
      if (this.get('isEditing')) {
        return this.send('stopEditing');
      } else {
        return this.send('startEditing');
      }
      return false;
    },

    startEditing: function() {
      if (this.get('isSaving')) {
        return null;
      }
      this.set('isEditing', true);

      const arr = this.get(this.relationship);

      this.createFormFromRelationship(this.get('model'), this.relationship, arr);

      Ember.run.next(() => {
        this.$('input.field:first').focus();
      });

      return false;
    },
    stopEditing: function() {
      if (this.isDestroyed || this.isDestroying) {
        return;
      }

      this.set('isSaving', true);
      this.set('isSubmitted', true);

      const self = this;

      Ember.run.next(() => {
        const errorMessages = this.get('errorMessages');

        if (errorMessages.get('length')) {
          return this.get('errorMessages').clear();
        }

        const arr = this.get(this.relationship);

        const model = this.get("model");

        this.setModelFromHash(model, this.relationship, arr);

        const finish = function() {
          this.get(this.relationship).clear();
          this.set('isEditing', false);
          this.set('isSaving', false);
          this.set('isSubmitted', false);
          this.get('errorMessages').clear();
          return Ember.run.next(function() {
            return model.trigger('modelUpdated', self, model);
          });
        };

        const isPrimaryCount = model.get(this.relationship).filter(function(i) {
          return i.get('isPrimary');
        }).toArray().length;

        Ember.assert("You have 0 or more than 1 multiples with isPrimary true", isPrimaryCount <= 1);

        if (!model.get('isDirty')) {
          finish();
        }

        model.save().then(finish)["finally"](function() {
          self.set('isSaving', false);
        });
      });
    }
  }
});