import Ember from 'ember';

import {isPrimaryComparer} from "radium/utils/computed";

const {
  Mixin
} = Ember;

export default Mixin.create({
  actions: {
    setPrimary: function(item) {
      Ember.run.next(() => {
        this.get('parent').setEach('isPrimary', false);

        item.set('isPrimary', true);
        if (this._actions.stopEditing) {
          return this.send('stopEditing');
        }

        return null;
      });

      return false;
    },
    removeSelection: function(item) {
      const parent = this.get('parent');
      const record = item.get('record');

      if (record) {
        let relationship;

        if(item.record.constructor === Radium.EmailAddress) {
          relationship = 'emailAddresses';
        } else {
          relationship = item.record.constructor === Radium.PhoneNumber ? 'phoneNumbers' : 'addresses';
        }

        this.send('removeMultiple', relationship, item.get('record'));
      }

      this.get('parent').removeObject(item);

      if (!parent.get('length')) {
        this.send('stopEditing');
      }

      const isPrimary = this.get('parent').find(function(item) {
        return item.get('isPrimary');
      });

      if (isPrimary) {
        this.send('stopEditing');
        return;
      }

      const nextIsPrimary = parent.find(function(i) {
        return i !== item;
      });

      nextIsPrimary.set('isPrimary', true);
    }
  },
  setModelFromHash: function(model, relationship, formArray) {
    formArray.forEach((item) => {
      if (item.hasOwnProperty('record') && item.get('value') !== "+1") {
        item.record.setProperties({
          name: item.get('name'),
          value: item.get('value'),
          isPrimary: item.get('isPrimary')
        });
      } else {
        if (item.get('value.length') && item.get('value') !== "+1") {
          this.get("model." + relationship).createRecord(item.getProperties('name', 'value', 'isPrimary'));
        }
      }
    });
  },

  createFormFromRelationship: function(model, relationship, formArray) {
    formArray.clear();

    const recordArray = model.get(relationship);

    if (!recordArray.get('length')) {
      return formArray.pushObject(Ember.Object.create({
        isPrimary: true,
        name: 'work',
        value: ''
      }));
    }
    recordArray.forEach(function(item) {
      return formArray.pushObject(Ember.Object.create({
        isPrimary: item.get('isPrimary'),
        name: item.get('name'),
        value: item.get('value'),
        record: item
      }));
    });
    return formArray = formArray.sort(isPrimaryComparer);
  }
});
