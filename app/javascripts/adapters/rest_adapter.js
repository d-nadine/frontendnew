Radium.RESTSerializer = DS.RESTSerializer.extend({
  addAttribute: function(hash, key, value) {
    switch(key){
      case 'created_at':
      case 'updated_at':
        return;
      case 'tag_names':
        hash['tags'] = value;
      default:
        this._super.apply(this, arguments);
    }
  },
});

Radium.RESTAdapter = DS.RESTAdapter.extend({
  serializer: Radium.RESTSerializer,

  ajax: function(url, type, hash) {
    hash = hash || {};
    hash.headers = hash.headers || {};
    hash.headers['X-Ember-Compat'] = "true";
    return this._super(url, type, hash);
  },

  findQuery: function(store, type, query, recordArray) {
    var recordType = type.toString().split(".")[1];
    var queryMethod = "query" + recordType + "Records";

    if(this[queryMethod]) {
      return this[queryMethod].call(this, store, type, query, recordArray, this._super);
    } else {
      this._super.apply(this, arguments);
    }
  },
  queryUserRecords: function(store, type, query, recordArray, base){
    if(query.name === "me"){
      var adapter = this;

      this.url;

      return this.ajax(this.url + '/users/me', "GET").then(function(json){
        var user = json.user;
        delete json.user;
        json.users = [user];
        Ember.run(adapter, function(){
          this.didFindQuery(store, type, json, recordArray);
        });
      }).then(null, function(error){
        Ember.Logger.error(error);
        throw error;
      });
    }else{
      var args = Array.prototype.call(arguments, 0, -1);
      base.apply(this, args);
    }
  }
});

Radium.RESTAdapter.configure('plurals',{
  company: 'companies'
});

Radium.RESTAdapter.registerTransform('object', {
  serialize: function(deserialized) {
    if(Ember.isNone(deserialized)) return null;

    var underscored = {}
    for(var key in deserialized) {
      underscored[key.underscore()] = deserialized[key];
    }

    return underscored;
  },

  deserialize: function(serialized) {
    if(Ember.isNone(serialized)) return null;

    var camelized = {}
    for(var key in serialized) {
      camelized[key.camelize()] = serialized[key];
    }

    return camelized;
  }
});

Radium.RESTAdapter.registerTransform('array', {
  serialize: function(deserialized){
    return deserialized;
  },
  deserialize: function(serialized){
    return serialized;
  },
});


Radium.RESTAdapter.registerTransform('datetime',  {
 deserialize: function(serialized) {
   if(serialized){
      return Ember.DateTime.parse(serialized);
    }
 },

 serialize: function(deserialized) {
   if(deserialized){
      return deserialized.toFullFormat();
    }
 }
});

Radium.RESTAdapter.map('Radium.Contact', {
  user: { key: 'assigned_to_id' },
  phoneNumbers: {embedded: 'always'},
  emailAddresses: {embedded: 'always'}
});

Radium.RESTAdapter.map('Radium.Todo', {
  user: { key: 'assigned_to_id' },
});

Radium.RESTAdapter.map('Radium.Deal', {
  isPublic: {key: 'public'},
  user: { key: 'assigned_to_id' },
});

Radium.RESTAdapter.map('Radium.Company', {
  user: { key: 'assigned_to_id' }
});

Radium.RESTAdapter.map('Radium.PhoneNumber', {
  value: { key: 'number' },
  isPrimary: { key: 'primary'},
});

Radium.RESTAdapter.map('Radium.EmailAddress', {
  value: { key: 'address' },
  isPrimary: { key: 'primary'},
});

Radium.RESTAdapter.map('Radium.Address', {
  isPrimary: { key: 'primary'},
});
