var get = Ember.get, set = Ember.set;

/**

  Borrows some methods from methods from DS.RESTAdapter. Because Radium's API
  isn't a traditional

  @extends DS.Adapter
*/
DS.RadiumAdapter = DS.Adapter.extend({
  bulkCommit: false,
  selectedUserID: null,
  createRecord: function(store, type, model) {
    // FIXME: For models without URL's like Notes we just want to avoid
    // persistance for now, but should look at a more elegant solution.
    if (type.url === false) {
      return false;
    }

    var root = (type.root) ? type.root : this.rootForType(type);
    var data = {};
    var hash = get(model, 'data');
    data[root] = hash.unsavedData;
    var url = (type.url) ? type.url : this.pluralize(root);

    var success = function(json) {
      this.sideload(store,type,json,root);
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
      this.sideload(store,type,json,plural);
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
    data[root] = get(model, 'data.unsavedData');
    if (model.get('url')) {
      url = model.get('url').fmt(id);
    } else {
      url = ["", this.pluralize(root), id].join("/");
    }

    this.ajax(url, "PUT", {
      data: data,
      success: function(json) {
      this.sideload(store,type,json,root);
        store.didUpdateRecord(model, json && json[root]);
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
      this.sideload(store,type,json,plural);
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
        primaryKey = get(type, 'proto.primaryKey');

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
        plural = this.pluralize(root);

    // If the request is for more records than what a page can return, proxy
    // to `findRecursively` to loop through the pages.
    if (ids.length > this.get('resultsPerPage')) {
      this.findRecursively(store, type, ids, plural);
    // Otherwise grab the first page of results and carry on.
    } else {
      var qsIds = typeof ids === "string" ? ids : ids.toString();

      this.ajax("/" + plural, "GET", {
        data: $.param({ids: ids}),
        success: function(json) {
          var arr = [];
          json[plural].forEach(function(item) {
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
        data: $.param({ids: ids, page: currentPage}),
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

  // Disable for now, probably will only make selective requests
  findAll: function(store, type, options) {
    var defaults = {local: false},
        settings = $.extend({}, defaults, type);
    if (!settings.local) {
      var root = this.rootForType(type),
          plural = this.pluralize(root);

      if (root === 'activity') return false;

      this.ajax("/" + plural, "GET", {
        success: function(json, status, xhr) {
          store.loadMany(type, json[plural]);
          this.sideload(store,type,json,plural);
        }
      });
    }
  },

  findQuery: function(store, type, query, modelArray) {
    var self = this,
        root = this.rootForType(type),
        plural = (type.root) ? this.pluralize(type.root) : this.pluralize(root),
        currentPage = 1,
        loadedJSON = [],
        url = (type.url) ? '/'+type.url : this.buildURL(root);

    if (query.page) {
      var loadPages = function(query) {
        var paginatedQuery = (query.page === 'all') ? jQuery.extend({}, query, {page: currentPage}) : query;

        self.ajax(url, "GET", {
          data: paginatedQuery,
          success: function(json) {
            var current = json.meta.pagination.current,
                total = json.meta.pagination.total,
                data = json[plural];

            loadedJSON = loadedJSON.concat(data);

            if (query.page === 'all' && current < total) {
              currentPage = current + 1;
              loadPages(query);
            } else {
              modelArray.load(loadedJSON);
              this.sideload(store, type, json, plural);
            }
          }
        });
      };
        loadPages(query);
    } else {
      this.ajax(url, "GET", {
        data: $.param(query),
        success: function(json) {
          var data = (type === Radium.Activity) ? self.normalize(json[plural]) : json[plural] ;
          modelArray.load(json[plural]);
          this.sideload(store, type, json, plural);
        }
      });
    }

  },

  // HELPERS

  /**
    Normalize nested data objects in activity models like todo and user.

    @param {Array} JSON response
  */
  normalize: function(data) {
    var normalized = data.map(function(item) {
      var kind = item.kind,
          reference = item.reference[kind];
      item[kind] = reference;
      item[kind].activity = item;
      item.user = (item.owner) ? item.owner.user : null;
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

    return jQuery.ajax(hash);
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
  },

  bootstrap: function() {
    var self = this;

    $.ajax({
      url: '/api/bootstrap',
      success: function(data) {
        self.loadBootstrapData(data);
      }
    });
  },

  loadDateBook: function (feed){
    var feedSection = Radium.FeedSection.create({store: Radium.store});

    [
      //['call_lists', Radium.CallList],
      //['campaigns', Radium.Campaign],
      //['deals', Radium.Deal],
      //['meetings', Radium.Meeting],
      ['todos', Radium.Todo]
    ].forEach(function(dateBookItem){
      var items = feed[dateBookItem[0]];
      if(items.length > 0) {
        items.forEach(function(item){
          Radium.store.load(dateBookItem[1], item);

          feedSection.pushItem(Radium.store.find(dateBookItem[1], item.id));
        });
      }
    });

    return feedSection;
  },

  loadBootstrapData: function(data) {
    var feedSection =  this.loadDateBook(data.feed.datebook_section);
    var feedController = Radium.router.get('feedController');
    feedController.pushObject(feedSection);
  }
});
