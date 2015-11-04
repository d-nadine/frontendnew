import Ember from 'ember';
import TimestampsMixin from 'radium/mixins/timestamps';

const {
  run,
  computed,
  RSVP,
  assert
} = Ember;

const Model = DS.Model.extend(TimestampsMixin, {
  primaryKey: 'id',
  flashMessenger: computed(function() {
    return this.store.container.lookup('service:flash-messenger');
  }),
  "delete": function() {
    const self = this;

    const flashMessenger =  this.get('flashMessenger');
    return new RSVP.Promise(function(resolve, reject) {
      self.deleteRecord();
      self.one('didDelete', function() {
        return resolve.call(self);
      });
      self.one('becameError', function() {
        flashMessenger.error('An error has occured and the deletion could not be completed.');

        self.reset();
        return reject.call(self);
      });
      self.one('becameInvalid', function() {
        flashMessenger.error(self);
        self.reset();
        return reject.call(self);
      });
      return self.get('store').commit();
    });
  },
  save: function() {
    const self = this;

    return new RSVP.Promise(function(resolve, reject) {
      var success;
      success = function(result) {
        return resolve(result);
      };

      self.one('didCreate', success);
      self.one('didUpdate', success);

      self.addErrorHandlers(reject);

      return self.get('store').commit();
    });
  },
  addErrorHandlers: function(reject) {
    const self = this;

    const flashMessenger = this.get('flashMessenger');

    this.one('becameInvalid', function(result) {
      flashMessenger.error(result);

      reject(result);
      return run.next(function() {
        if (self.get('id')) {
          return self.reset();
        } else {
          result.reset();
          return result.unloadRecord();
        }
      });
    });
    return this.one('becameError', function(result) {
      if (self.get('id')) {
        self.reset();
      }

      flashMessenger.error('An error has occurred and the operation could not be completed.');

      reject(result);
      if (result.get('id')) {
        return;
      }

      run.next(function() {
        result.reset();
        return result.unloadRecord();
      });
    });
  },
  updateLocalBelongsTo: function(key, belongsTo, notify) {
    var data;
    if (notify == null) {
      notify = true;
    }
    data = this.get('data');
    data[key] = {
      id: belongsTo.get('id'),
      type: belongsTo.constructor
    };
    this.set('_data', data);
    if (!notify) {
      return;
    }
    this.suspendRelationshipObservers(function() {
      return this.notifyPropertyChange('data');
    });

    this.updateRecordArrays();
  },
  updateHasMany: function(key, newItemId, klass) {
    var data, item, loader, references, serializer, store;
    assert("No newListId found to update local hasMany", newItemId);
    data = this.get('_data');
    store = this.get('store');
    serializer = this.get('store._adapter.serializer');
    loader = DS.loaderFor(store);
    references = data[key].map(function(item) {
      return {
        id: item.id,
        type: klass
      };
    });
    item = Radium.List.all().find(function(t) {
      return t.get('id') === newItemId;
    });
    if (!references.any(function(item) {
      return item.id === newItemId;
    })) {
      references.push({
        id: newItemId,
        type: klass
      });
    }
    references = this._convertTuplesToReferences(references);
    data[key] = references;
    this.set('_data', data);
    this.suspendRelationshipObservers(function() {
      return this.notifyPropertyChange('data');
    });
    return this.updateRecordArrays();
  },
  updateLocalProperty: function(property, value, notify) {
    var data;
    if (notify == null) {
      notify = true;
    }
    data = this.get('data');
    data[property] = value;
    this.set('_data', data);
    if (!notify) {
      return;
    }

    this.suspendRelationshipObservers(function() {
      return this.notifyPropertyChange('data');
    });
  },
  shallowCopy: function() {
    var hash, self;
    self = this;
    hash = {};
    this.eachAttribute(function(key) {
      var val;
      if ((val = self.get(key))) {
        return hash[key] = val;
      }
    });
    return hash;
  },
  reload: function() {
    if (!this.get('inCleanState')) {
      return;
    }

    this._super(...arguments);
  },
  typeName: computed(function() {
    return this.constructor.toString().underscore().split('.').pop().toLowerCase();
  }),
  inErrorState: computed('currentState.stateName', function() {
    return this.get('currentState.stateName') === 'root.error';
  }),
  inCleanState: computed('currentState.stateName', function() {
    return this.get('currentState.stateName') === "root.loaded.saved";
  }),
  reset: function() {
    var state;
    state = this.get('id') ? "loaded.saved" : "loaded.created.uncommitted";
    this.get('transaction').rollback();
    this.transitionTo(state);
    if (this.get('id')) {
      return this.reload();
    }
  },

  deleteRecord: function() {
    if (!this.get('inCleanState')) {
      return;
    }
    return this.send('deleteRecord');
  },

  updatedEventKey: function() {
    return (this.constructor.toString()) + ":" + (this.get('id')) + ":update}";
  },

  reloadAfterUpdateEvent: function(event) {
    if (event == null) {
      event = 'didCreate';
    }
    return this.one(event, function(result) {
      return this.reloadAfterUpdate.call(result);
    });
  },
  reloadAfterUpdate: function() {
    const observer = function() {
      if (this.get('inCleanState')) {
        this.removeObserver('currentState.stateName', observer);
        return this.reload();
      }
    };

    return this.addObserver('currentState.stateName', observer);
  },
  executeWhenInCleanState: function(func) {
    const observer = () => {
      if (!this.get('inCleanState')) {
        return;
      }

      this.removeObserver('currentState.stateName', observer);
      func();
    };

    if (this.get('inCleanState')) {
      return observer();
    } else {
      return this.addObserver('currentState.stateName', observer);
    }
  }
});

export default Model;
