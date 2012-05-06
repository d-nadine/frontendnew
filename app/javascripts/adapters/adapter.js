var get = Ember.get, set = Ember.set, getPath = Ember.getPath;

/**

  Borrows some methods from methods from DS.RESTAdapter. Because Radium's API
  isn't a traditional

  @extends DS.Adapter
*/
DS.RadiumAdapter = DS.Adapter.extend({
  bulkCommit: false,
  selectedUserID: null,
  createRecord: function(store, type, model) {
    var root = (type.root) ? type.root : this.rootForType(type);
    var data = {};
    var hash = get(model, 'data');
    data[root] = hash.unsavedData;
    var url = (type.url) ? type.url : this.puralize(root);

    var success = function(json) {
      this.sideload(store,type,json,root)
      store.didCreateRecord(model, json[root]);
    };
    
    this.ajax("/" + url, "POST", {
      data: data,
      success: success
    }, {
      store: store,
      model: model
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
      this.sideload(store,type,json,plural)
      store.didCreateRecords(type, models, json[plural]);
    };

    this.ajax("/" + this.pluralize(root), "POST", {
      data: data,
      success: success
    });
  },

  updateRecord: function(store, type, model) {
    var url;
    var id = get(model, 'id');
    var root = (type.root) ? type.root : this.rootForType(type);
    var data = {};
    data[root] = getPath(model, 'data.unsavedData');
    if (model.get('url')) {
      url = model.get('url').fmt(id);
    } else {
      url = ["", this.pluralize(root), id].join("/");
    }

    this.ajax(url, "PUT", {
      data: data,
      success: function(json) {
      this.sideload(store,type,json,root)
        store.didUpdateRecord(model, json[root]);
      }
    }, {
      store: store,
      model: model
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
      this.sideload(store,type,json,plural)
        store.didUpdateRecords(models, json[plural]);
      }
    });
  },

  deleteRecord: function(store, type, model) {
    var id = get(model, 'id');
    var root = this.rootForType(type);

    var url = ["", this.pluralize(root), id].join("/");

    this.ajax(url, "DELETE", {
      success: function(json) {
        if(json){ this.sideload(store,type,json); }
        store.didDeleteRecord(model);
      }
    }, {
      store: store,
      model: model
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
        if(json) { this.sideload(store,type,json); }
        store.didDeleteRecords(models);
      }
    });
  },

  find: function(store, type, id) {
    var root = this.rootForType(type);

    var url = ["", this.pluralize(root), id].join("/");

    this.ajax(url, "GET", {
      success: function(json) {
        store.load(type, json[root]);
        this.sideload(store,type,json,root);
      }
    });
  },

  findMany: function(store, type, ids) {
    var root = this.rootForType(type),
        plural = this.pluralize(root),
        userID = this.get('selectedUserID');
    // Activities have to be loaded via their type, ie users, contacts, deals
    if (root === 'activity') {
      plural = ["users", userID, "feed"].join("/");
    }
    // If the request is for more records than what a page can return, proxy
    // to `findRecursively` to loop through the pages.
    if (ids.length > this.get('resultsPerPage')) {
      this.findRecursively(store, type, ids, plural);
    // Otherwise grab the first page of results and carry on.
    } else {
      this.ajax("/" + plural, "GET", {
        data: { ids: ids },
        success: function(json) {
          var arr = [];
          json.forEach(function(item) {
            arr.push(item.id);
          });
          store.loadMany(type, ids, json[plural]);
          this.sideload(store,type,json,plural);
        }
      });
    }
  },

  /**
    Loops through paginated resources.
  */
  findRecursively: function(store, type, ids, plural) {
    // Set up the deffered
    var self = this,
        // Calculate the total number of pages via the number of id's requested
        totalPages = Math.ceil(ids.length / this.get('resultsPerPage')),
        currentPage = 1,
        ids = ids || [],
        dataHash = [];

    var fetchPage = function() {
      self.ajax("/"+plural, "GET", {
        data: {ids: ids, page: currentPage},
        success: function(json, status, xhr) {
          // On the last page, send to `pagesLoaded` to add to store.
          if (currentPage >= totalPages) {
            dataHash = dataHash.concat(json);
            pagesLoaded();
          // Loop on through the pages
          } else {
            currentPage++;
            dataHash = dataHash.concat(json);
            fetchPage();
          }
        }
      });
    };

    var pagesLoaded = function() {
      store.loadMany(type, ids, dataHash);
    };

    fetchPage();
  },

  findAll: function(store, type) {
    var root = this.rootForType(type),
        plural = this.pluralize(root);

    if (root === 'activity') return false;

    this.ajax("/" + plural, "GET", {
      success: function(json, status, xhr) {
        var controllerName = plural.camelize();

        store.loadMany(type, json[plural]);
        this.sideload(store,type,json,plural);

        Radium[controllerName + 'Controller'].setProperties({
          currentPage: json.meta.pagination.current,
          totalPages: json.meta.pagination.total
        });
      }
    });
  },

  findQuery: function(store, type, query, modelArray) {
    var root = this.rootForType(type), plural = this.pluralize(root);

    this.ajax(this.buildURL(root), "GET", {
      data: query,
      success: function(json) {
        var controllerName = plural.camelize();
        modelArray.load(json[plural]);
        this.sideload(store, type, json, plural);

        Radium[controllerName+'Controller'].setProperties({
          currentPage: json.meta.pagination.current,
          totalPages: json.meta.pagination.total
        });
      }
    });
  },

  // findQuery: function(store, type, query, modelArray) {
  //   var resource,
  //       url,
  //       self = this,
  //       // If no page is declared, load page 1 by default.
  //       currentPage = query.page || 1,
  //       root = this.rootForType(type),
  //       url = this.pluralize(root),
  //       plural = url,
  //       // Cache all the hashes here if they are spread out across several pages.
  //       dataHash = [];
  //   // Activities have to be loaded via their type, ie users, contacts, deals
  //   if (root === 'activity') {
  //     url = [query.type+"s", query.id, "feed"].join("/");
  //   } else {
  //     url = this.pluralize(root)
  //   }

  //   var fetchPage = function() {
  //     self.ajax("/"+url, "GET", {
  //       data: {page: currentPage},
  //       success: function(json, status, xhr) {
  //         // A page=0 query loads all available pages.
  //         var totalPages = json.meta.pagination.total,
  //             controllerName = url.camelize();
  //         if (query.page === 0) {
  //           // If we are on the last page, cache the hash and then wrap up
  //           if (currentPage >= totalPages) {
  //             dataHash = dataHash.concat(json);
  //             pagesLoaded(dataHash);
  //           // Otherwise loop on to the next page
  //           } else {
  //             currentPage++;
  //             dataHash = dataHash.concat(json);
  //             fetchPage();
  //           }
  //         } else {
  //           Radium[controllerName + 'Controller'].setProperties({
  //             totalPages: totalPages,
  //             totalPagesLoaded: query.page
  //           });
  //           pagesLoaded(json);
  //         }
  //       }
  //     });
  //   };
  //   // Notify the ModelArray that we've got all the models.
  //   var pagesLoaded = function(dataHash) {
  //     var data = self.normalize(dataHash)[0];
  //     modelArray.load(data[plural]);
  //     self.sideload(store,type,data,plural);
  //   };
  //   // Init.
  //   fetchPage();
  // },

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
        item.owner.guid = Math.ceil(Math.random() * 10000);
        item.reference.guid = Math.ceil(Math.random() * 10000);
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

  sideload: function(store, type, json, root) {
    var sideloadedType, mappings;

    for (var prop in json) {
      if (!json.hasOwnProperty(prop)) { continue; }
      if (prop === root) { continue; }
      if (prop === 'meta') { continue; }

      sideloadedType = type.typeForAssociation(prop);

      if (!sideloadedType) {
        mappings = get(this, 'mappings');

        ember_assert("Your server returned a hash with the key " + prop + " but you have no mappings", !!mappings);

        sideloadedType = get(get(this, 'mappings'), prop);

        ember_assert("Your server returned a hash with the key " + prop + " but you have no mapping for it", !!sideloadedType);
      }

      this.loadValue(store, sideloadedType, json[prop]);
    }
  },

  ajax: function(url, type, hash, adapterContext) {
    hash.url = '/api' + url;
    hash.type = type;
    hash.context = this;
    hash.error = function(jqXHR, textStatus, errorThrown) {
      Radium.ErrorManager.send('displayError', {
        status: jqXHR.status,
        responseText: jqXHR.responseText
      });

      if (jqXHR.status === 422 && adapterContext.model && adapterContext.store) {
        var data = JSON.parse(jqXHR.responseText);
        adapterContext.store.recordWasInvalid(adapterContext.model, data['errors']);
      }
    };

    if (hash.data && type !== 'GET') {
      hash.data = JSON.stringify(hash.data);
    }

    var request = jQuery.extend(hash, CONFIG.ajax);

    jQuery.ajax(request);
  },

  buildURL: function(model, suffix) {
    var url = [""];

    if (this.namespace !== undefined) {
      url.push(this.namespace);
    }

    url.push(this.pluralize(model));
    if (suffix !== undefined) {
      url.push(suffix);
    }

    return url.join("/");
  }
});
