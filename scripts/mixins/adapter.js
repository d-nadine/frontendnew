define(function(require) {
  require('ember');
  require('data');

  var get = Ember.get, set = Ember.set, getPath = Ember.getPath;

  var RadiumAdapter;

  RadiumAdapter = DS.Adapter.extend({
    bulkCommit: false,
    createRecord: function(store, type, model) {
      var root = this.rootForType(type);
      var data = get(model, 'data');
      var url = this.pluralize(root);
      var success = function(json) {
        store.didCreateRecord(model, json);
      };
       
      if (model.get('_type')) {
        url = [
                this.pluralize(model.get('_type')),
                model.get('relation'),
                this.pluralize(this.rootForType(type))
              ].join('/')
      }
            
      this.ajax("/" + url, "POST", {
        data: data,
        success: success
      });
    },

    createRecords: function(store, type, models) {
      if (get(this, 'bulkCommit') === false) {
        return this._super(store, type, models);
      }
      
      var root = this.rootForType(type),
          plural = this.pluralize(root);

      var data = models.map(function(model) {
        return get(model, 'data');
      });
      
      var success = function(json) {
        store.didCreateRecords(type, models, json);
      };

      this.ajax("/" + this.pluralize(root), "POST", {
        data: data,
        success: success
      });
    },

    updateRecord: function(store, type, model) {
      var id = get(model, 'id');
      var root = this.rootForType(type);

      var data = {};
      data[root] = get(model, 'data');

      var url = ["", this.pluralize(root), id].join("/");

      this.ajax(url, "PUT", {
        data: data,
        success: function(json) {
          store.didUpdateRecord(model, json);
        }
      });
    },

    updateRecords: function(store, type, models) {
      if (get(this, 'bulkCommit') === false) {
        return this._super(store, type, models);
      }

      var root = this.rootForType(type),
          plural = this.pluralize(root);

      var data = {};
      data[plural] = models.map(function(model) {
        return get(model, 'data');
      });

      this.ajax("/" + this.pluralize(root), "POST", {
        data: data,
        success: function(json) {
          store.didUpdateRecords(models, json);
        }
      });
    },

    deleteRecord: function(store, type, model) {
      var id = get(model, 'id');
      var root = this.rootForType(type);

      var url = ["", this.pluralize(root), id].join("/");

      this.ajax(url, "DELETE", {
        success: function(json) {
          store.didDeleteRecord(model);
        }
      });
    },

    deleteRecords: function(store, type, models) {
      if (get(this, 'bulkCommit') === false) {
        return this._super(store, type, models);
      }

      var root = this.rootForType(type),
          plural = this.pluralize(root),
          primaryKey = getPath(type, 'proto.primaryKey');

      var data = {};
      data[plural] = models.map(function(model) {
        return get(model, primaryKey);
      });

      this.ajax("/" + this.pluralize(root) + "/delete", "POST", {
        data: data,
        success: function(json) {
          store.didDeleteRecords(models);
        }
      });
    },

    find: function(store, type, id) {
      var root = this.rootForType(type);

      var url = ["", this.pluralize(root), id].join("/");

      this.ajax(url, "GET", {
        success: function(json) {
          store.load(type, json);
        }
      });
    },

    findMany: function(store, type, ids) {
      var root = this.rootForType(type), plural = this.pluralize(root);

      this.ajax("/" + plural, "GET", {
        data: { ids: ids },
        success: function(json) {
          store.loadMany(type, ids, json);
        }
      });
    },

    findAll: function(store, type) {
      var root = this.rootForType(type), plural = this.pluralize(root);

      this.ajax("/" + plural, "GET", {
        success: function(json) {
          store.loadMany(type, json);
        }
      });
    },

    findQuery: function(store, type, query, modelArray) {
      var root = this.rootForType(type), plural = this.pluralize(root);

      this.ajax("/" + plural, "GET", {
        data: query,
        success: function(json) {
          modelArray.load(json);
        }
      });
    },

    // HELPERS

    plurals: {
      'activity': 'activities'
    },

    // define a plurals hash in your subclass to define
    // special-case pluralization
    pluralize: function(name) {
      return this.plurals[name] || name + "s";
    },

    rootForType: function(type) {
      if (type.url) { return type.url; }

      // use the last part of the name as the URL
      var parts = type.toString().split(".");
      var name = parts[parts.length - 1];
      return name.replace(/([A-Z])/g, '_$1').toLowerCase().slice(1);
    },

    ajax: function(url, type, hash) {
      hash.url = url;
      hash.type = type;
      hash.dataType = "json";

      jQuery.ajax(hash);
    }
  });

  return RadiumAdapter;
});