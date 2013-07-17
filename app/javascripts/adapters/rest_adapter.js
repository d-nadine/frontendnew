Radium.RESTSerializer = DS.RESTSerializer.extend({
  addAttribute: function(hash, key, value) {
    switch(key){
      case 'created_at':
      case 'updated_at':
        return;
      default:
        this._super.apply(this, arguments);
    }
  },

  // FIXME: Remove
  addHasMany: function(hash, record, key, relationship) {
    this._super.apply(this, arguments);
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
      var date = Ember.DateTime.parse(serialized);
      date.adjust({timezone: Radium.timezone});
      return date;
    }
 },

 serialize: function(deserialized) {
   if(deserialized){
      return deserialized.toFullFormat();
    }
 }
});

Radium.RESTAdapter.map('Radium.Account', {
  workflow: {embedded: 'always'},
});

Radium.RESTAdapter.map('Radium.Workflow', {
  checklist: {key: 'check_list', embedded: 'always'},
});

Radium.RESTAdapter.map('Radium.Contact', {
  isPublic: {key: 'public'},
  user: { key: 'assigned_to_id' },
  phoneNumbers: {embedded: 'always'},
  emailAddresses: {embedded: 'always'},
  addresses: {embedded: 'always'},
  tagNames: {embedded: 'always'},
  comments: {embedded: 'load'},
});

Radium.RESTAdapter.map('Radium.Discussion', {
  user: {key: 'posted_by'},
  comments: {embedded: 'load'},
});

Radium.RESTAdapter.map('Radium.Deal', {
  isPublic: {key: 'public'},
  user: { key: 'assigned_to_id' },
  reason: { key: 'lost_because' },
  checklist: { key: 'check_list' ,embedded: 'always' },
});

Radium.RESTAdapter.map('Radium.ChecklistItem', {
  isFinished: {key: 'finished'},
});

Radium.RESTAdapter.map('Radium.Company', {
  user: { key: 'assigned_to_id' },
  addresses: {embedded: 'always'},
  tagNames: {embedded: 'always'},
});

Radium.RESTAdapter.map('Radium.PhoneNumber', {
  value: { key: 'number' },
  isPrimary: { key: 'primary'},
});

Radium.RESTAdapter.map('Radium.Email', {
  message: {key: 'body'},
  isPublic: {key: 'public'},
  isRead: {key: 'read'},
  isPersonal: {key: 'personal'},
  comments: {embedded: 'load'},
});

Radium.RESTAdapter.map('Radium.EmailAddress', {
  value: { key: 'address' },
  isPrimary: { key: 'primary'},
});

Radium.RESTAdapter.map('Radium.Address', {
  isPrimary: { key: 'primary'},
});

Radium.RESTAdapter.map('Radium.Todo', {
  isFinished: {key: 'finished'},
  finishBy: {key: 'time'},
  user: { key: 'assigned_to_id' },
  comments: {embedded: 'load'},
});

Radium.RESTAdapter.map('Radium.Call', {
  isFinished: {key: 'finished'},
  finishBy: {key: 'time'},
  user: { key: 'assigned_to_id' },
  comments: {embedded: 'load'},
});

Radium.RESTAdapter.map('Radium.Meeting', {
  isFinished: {key: 'finished'},
  finishBy: {key: 'time'},
  user: { key: 'assigned_to_id' },
  comments: {embedded: 'load'},
});
