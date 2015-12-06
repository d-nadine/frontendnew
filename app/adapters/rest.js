import Ember from 'ember';

(function () {
   'use strict';
}());

var get = Ember.get, set = Ember.set,
  map = Ember.EnumerableUtils.map;

var RESTSerializer = DS.RESTSerializer.extend({
  init: function(){
    this._super.apply(this, arguments);
    this.configure({
      meta: 'meta',
      since: 'next',
      page: 'page',
      totalPages: 'total_pages',
      totalRecords: 'total_records',
      isLastPage: 'last_page'
    });
  },

  addAttribute: function(hash, key) {
    switch(key){
    case 'created_at':
    case 'updated_at':
      return;
      default:
        this._super.apply(this, arguments);
    }
  },

  addHasMany: function(hash, record, key, relationship) {
    if(['attachment_ids'].indexOf(key) === -1){
      return this._super.apply(this, arguments);
    }

    var name = relationship.key,
        manyArray = get(record, name);

    hash[key] = manyArray.map(function(item){
      return item.get('id');
    });
  },

  extractValidationErrors: function(type, json) {
    var errors = {},
        self = this,
        attributes = get(type, 'attributes').keys.list.map(function(name) {
          return self._keyForAttributeName(type, name);
        }),
        errorKeys = [];

    for(var errorKey in json['errors']) {
      if(errorKey) {
        errorKeys.push(errorKey);
      }
    }

    attributes.forEach(function(name) {
      if (json['errors'].hasOwnProperty(name)) {
        errors[name] = json['errors'][name];
      }
    }, this);

    var i, key, len = errorKeys.length;

    for(i = 0; i < len; i++) {
      key = errorKeys[i];
      if(key && !attributes.contains(key)) {
        errors[this.printFriendlyName(key)] = json['errors'][key];
      }
    }

    return errors;
  },

  printFriendlyName: function(key) {
    var map = {};
    map["email_addresses"] = "email address";

    return map[key] || key.humanize();
  }
});

var RESTAdapter = DS.RESTAdapter.extend({
  serializer: RESTSerializer,

  didError: function(store, type, record, xhr){
    if ([400, 402, 403, 409, 412].contains(xhr.status) ){
      var json,
          errors = {};

      json = xhr.responseText.length ? JSON.parse(xhr.responseText) : {errors: {message: "An unknown error has occurred."}};

      if(!json.hasOwnProperty('error')){
        this._super.apply(this, arguments);
      }else{
        // FIXME: We need better error messages from the server
        switch(json.error){
          case "EditUser::NonAdminUserForbindden":
          case "EditAccount::NonAdminUserForbindden":
            errors.message = "You need to be an admin user to perform this action";
            break;
          case "Todo::PersonalEmailForbidden":
            errors.message = "You cannot create a todo from a personal email";
            break;
          default:
            errors.error = json.error;
        }

        store.recordWasInvalid(record, errors);
      }
    } else {
      this._super.apply(this, arguments);
    }
  },

  findHasMany: function(store, record, relationship, options) {
    if(relationship.key !== 'activities') {
      return;
    }

    options = options || {url: '/' + record.humanize().pluralize() + '/' + record.get('id') + '/activities'};

    var type = relationship.type,
        url = this.url + options.url,
        self = this;

    this.ajax(url, "GET", {
      data: {page: options.page}
    }).then(function(json) {
      var data = record.get('_data'),
        ids = [],
        references = json[relationship.key] || [];

      ids = references.map(function(ref){
        return ref.id;
      });

      var raw = data[relationship.key];

      if(Ember.isArray(raw)) {
        data[relationship.key] = raw.concat(ids).uniq();
      } else {
        data[relationship.key] = ids;
      }

      raw = data[relationship.key];

      record.set('_data', data);

      self.didFindMany(store, type, json);

      record.suspendRelationshipObservers(function() {
        var cachedValue = record.cacheFor(relationship.key);

        var references = map(raw, function(id) {
          if (typeof id === 'object') {
            if( id.clientId ) {
              // if it was already a reference, return the reference
              return id;
            } else {
              // <id, type> tuple for a polymorphic association.
              return store.referenceForId(id.type, id.id);
            }
          }
          return store.referenceForId(type, id);
        });

        set(cachedValue, 'content', Ember.A(references));
      });

      var metadata = store.typeMapFor(type).metadata;

      record.get(relationship.key).set('metadata', metadata);

      if(options.callback){
        options.callback(metadata);
      }
    }).then(null, DS.rejectionHandler);
  },

  findQuery: function(store, type, query, recordArray) {
    var recordType = type.toString().split(".")[1];
    var queryMethod = "query" + recordType + "Records";

    if(this[queryMethod]) {
      return this[queryMethod].call(this, store, type, query, recordArray, this._super);
    }

    return this._super.apply(this, arguments);
  },

  queryEmailRecords: function(store, type, query, recordArray, base){
    var root, adapter, url, page, pageSize;
    if(query.name === 'reply_thread') {
      root = this.rootForType(type);
      adapter = this;
      url = this.url + '/email_replies/' + query.emailId;

      delete query.name;
      delete query.emailId;

      return this.ajax(url, 'GET', {
        data: query
      }).then(function(json){
        adapter.didFindQuery(store, type, json, recordArray);
      }).then(null, DS.rejectionHandler);
    }
    else if(['incoming', 'replied', 'waiting', 'later', 'archived', 'ignored', 'team', 'shared'].contains(query.name)){
      root = this.rootForType(type);
      adapter = this;
      page = query.page || 1;
      pageSize = query.pageSize;

      var user = query.user;

      url = this.url + '/conversations/' + query.name + '?page=' + page +  '&page_size=' + pageSize;

      if(user) {
        url += '&user=' + user;
        delete query.user;
      }

      delete query.name;
      delete query.page;
      delete query.pageSize;

      return this.ajax(url, 'GET', {
        data: query
      }).then(function(json){
        adapter.didFindQuery(store, type, json, recordArray);
      }).then(null, DS.rejectionHandler);
    }else {
      var args = Array.prototype.slice.call(arguments, 0, -1);
      base.apply(this, args);
    }
  },

  queryUserRecords: function(store, type, query, recordArray, base){
    if(query.name === "me"){
      var adapter = this;

      return this.ajax(this.url + '/users/me', "GET").then(function(json){
        var user = json.user;
        delete json.user;
        json.users = [user];
        Ember.run(adapter, function(){
          this.didFindQuery(store, type, json, recordArray);
        });
      }).catch(function(err){
        Ember.$.removeCookie('token', window.Radium.get('cookieDomain'), {path: '/'});
        var message = null;

        if(err.message) {
          message = err.message;
        }
        else{
          message = 'The "me" user was not found for some reason!';
        }

        throw new Error(message);
      });
    }else{
      var args = Array.prototype.slice.call(arguments, 0, -1);
      base.apply(this, args);
    }
  }
});

RESTAdapter.configure('plurals',{
  reply: 'replies',
  company: 'companies',
  user_invitation_delivery: 'user_invitation_deliveries',
  autocomplete_item: 'autocomplete',
  settings: 'settings',
  user_settings: 'user_settings',
  activity: 'activities',
  destroy: 'destroy',
  user_statistics: 'user_statistics',
  billing: 'billing',
  addressbook_totals: 'addressbook_totals',
  conversations_totals: 'conversations_totals',
  contacts_totals: 'contacts_totals',
  track_all_contacts: 'track_all_contacts',
  contact_status: 'contact_statuses',
  list_status: 'list_statuses',
  move_list_status: 'move_list_statuses',
  untracked_contacts_totals: 'untracked_contacts_totals',
  market_category: 'market_categories',
  technology: 'technologies'
});

RESTAdapter.registerTransform('object', {
  serialize: function(deserialized) {
    if(Ember.isNone(deserialized)){
      return null;
    }

    var underscored = {};

    for(var key in deserialized) {
      underscored[key.underscore()] = deserialized[key];
    }

    return underscored;
  },

  deserialize: function(serialized) {
    if(Ember.isNone(serialized)){
      return null;
    }

    var camelized = {};
    for(var key in serialized) {
      camelized[key.camelize()] = serialized[key];
    }

    return camelized;
  }
});

RESTAdapter.registerTransform('array', {
  serialize: function(deserialized){
    return deserialized;
  },
  deserialize: function(serialized){
    return serialized;
  }
});

RESTAdapter.registerTransform('datetime',  {
 deserialize: function(serialized) {
   if(serialized){
      var date = Ember.DateTime.parse(serialized);
      return date.adjust({timezone: window.Radium.timezone});
   }

   return null;
 },

 serialize: function(deserialized) {
   if(deserialized){
      return deserialized.toFullFormat();
   }

   return null;
 }
});

// RESTAdapter.map('Radium.Activity', {
//   note: {embedded: 'load'}
// });

var contactsMapping = {
  isPublic: {key: 'public'},
  user: { key: 'assigned_to_id' },
  //phoneNumbers: {embedded: 'always'},
  emailAddresses: {embedded: 'always'},
  //addresses: {embedded: 'always'},
  //comments: {embedded: 'load'},
  //customFieldValues: {embedded: 'always'},
  contactInfo: {embedded: 'always'}
};

RESTAdapter.map('Radium.Contact', contactsMapping);
// RESTAdapter.map('Radium.CreateContact', contactsMapping);

// RESTAdapter.map('Radium.ContactImportJob', {
//   importErrors: {embedded: 'load'}
// });

RESTAdapter.map('Radium.ContactInfo', {
  socialProfiles: {embedded: 'always'}
});

RESTAdapter.map('Radium.Deal', {
  isPublic: {key: 'public'},
  user: { key: 'assigned_to_id' },
  contactRefs: {embedded: 'always'}
});

RESTAdapter.map('Radium.Company', {
  user: { key: 'assigned_to_id' },
  addresses: {key: 'offices', embedded: 'always'},
  phoneNumbers: {embedded: 'always'},
  socialProfiles: {embedded: 'load'},
  technologies: {embedded: 'load'},
  marketCategories: {embedded: 'load'}
});

RESTAdapter.map('Radium.PhoneNumber', {
  value: { key: 'number' },
  isPrimary: { key: 'primary'}
});

RESTAdapter.map('Radium.Email', {
  message: {key: 'body'},
  isPublic: {key: 'public'},
  isRead: {key: 'read'},
  isPersonal: {key: 'personal'},
  isDraft: {key: 'draft'},
  comments: {embedded: 'load'}
});

// RESTAdapter.map('Radium.BulkEmailJob', {
//   message: {key: 'body'},
//   isDraft: {key: 'draft'},
// });

RESTAdapter.map('Radium.EmailAddress', {
  value: { key: 'address' },
  isPrimary: { key: 'primary'}
});

RESTAdapter.map('Radium.Address', {
  isPrimary: { key: 'primary'}
});

RESTAdapter.map('Radium.Todo', {
  isFinished: {key: 'finished'},
  finishBy: {key: 'time'},
  user: { key: 'assigned_to_id' },
  comments: {embedded: 'load'}
});

// RESTAdapter.map('Radium.Note', {
//   comments: {embedded: 'load'}
// });

RESTAdapter.map('Radium.Meeting', {
  isFinished: {key: 'finished'},
  finishBy: {key: 'time'},
  user: { key: 'assigned_to_id' },
  comments: {embedded: 'load'}
});

// RESTAdapter.map('Radium.UserInvitation', {
//   email: {key: 'address'}
// });

RESTAdapter.map('Radium.User', {
  isAdmin: {key: 'admin'},
  settings: {key: 'settings_id'},
  contactInfo: {embedded: 'always'}
  //customQueries: {embedded: 'always'}
});

// RESTAdapter.map('Radium.CustomQuery', {
//   customQueryParts: {embedded: 'always'}
// });

RESTAdapter.map('Radium.UserSettings', {
  notifications: {embedded: 'always'},
  alerts: {embedded: 'always'}
});

RESTAdapter.map('Radium.NotificationSettings', {
  overdueTasks: {embedded: 'always'},
  createdOverdueTasks: {embedded: 'always'},
  localMeetings: {embedded: 'always'},
  remoteMeetings: {embedded: 'always'},
  leadIgnored: {embedded: 'always'},
  clientIgnored: {embedded: 'always'},
  taskIgnored: {embedded: 'always'}
});

// RESTAdapter.map('Radium.Comment', {
//   user: {key: 'author_id'}
// });

export default RESTAdapter;
