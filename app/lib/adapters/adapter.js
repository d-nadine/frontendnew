var get = Ember.get, set = Ember.set, getPath = Ember.getPath;

window.RadiumAdapter = DS.Adapter.extend({
  bulkCommit: false,
  createRecord: function(store, type, model) {
    var root = this.rootForType(type);
    var data = get(model, 'data');
    var url = (type.url) ? type.url : this.pluralize(root);
    var success = function(json) {
      store.didCreateRecord(model, json);
    };

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
    var url;
    var id = get(model, 'id');
    var root = this.rootForType(type);
    var data = {};
    data[root] = get(model, 'data');
    if (model.get('url')) {
      url = model.get('url').fmt(id);
    } else {
      url = ["", this.pluralize(root), id].join("/");
    }
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
    
    // Set up the deffered
    var totalPages = 0,
        currentPage = 0;
        console.log(ids.get('length'));
    this.ajax("/" + plural, "GET", {
      data: { ids: ids },
      success: function(json, status, xhr) {
        totalPages = xhr.getResponseHeader('x-radium-total-pages'),
        currentPage = xhr.getResponseHeader('x-radium-current-page');
        console.log('results from page %@ of %@.'.fmt(page, totalPages));
        if (totalPages === 1) {
          store.loadMany(type, ids, json);
        } else {

        }
      },
      error: function() {
        console.log(arguments);
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
    var resource,
        url,
        data = {},
        self = this,
        page = query.page,
        root = this.rootForType(type),
        url = this.pluralize(root);

    if (root === 'activity') {
      url = [query.type+"s",query.id,"feed"].join("/");
    }

    if (root.match(/(deal|user)/)) {
      url = this.pluralize(root)
      data['page'] = query.page;
    }

    this.ajax("/"+url, "GET", {
      data: data,
      success: function(json) {
        // Normalize nested elements without ID's
        var data = self.normalize(json);
        modelArray.load(data);
      }
    });
  },

  // HELPERS

  /**
    Normalize nested JSON resources returned without a unique id that are 
    nested 2 or more levels deep. For example, the code will take this 
    JSON response:

    ```
    [{
      id: 52,
      owner: {
        user: {
          id: 11
        }
      }
    }];
    ```
    to:
    ```
    [{
      id: 52,
      owner: {
        id: R83968
        user: {
          id: 11
        }
      }
    }];
    ```
    It also prepends an 'R' to avoid any possible ID collision.

    @param {Array} JSON response
  */
  normalize: function(data) {
    var normalized = data.map(function(item) {
      if (item.hasOwnProperty('owner') && item.hasOwnProperty('reference')) {
        item.owner.id = "R"+ Math.ceil(Math.random() * 10000);
        item.reference.id = "R"+ Math.ceil(Math.random() * 10000);
      }
      return item;
    });
    return normalized;
  },

  plurals: {
    'activity': 'activities',
    'sms': 'sms'
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
    hash.url = '/api' + url;
    hash.type = type;
    hash.dataType = "json";

    jQuery.ajax(hash);
  }
});