Radium.RESTAdapter = DS.RESTAdapter.extend({
  createRecord: function(store, type, record) {
    if(type == Radium.CurentUser) return;

    this._super.apply(this, arguments);
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


Radium.RESTAdapter.registerTransform('datetime',  {
 deserialize: function(serialized) {
   return null;
 },

 serialize: function(deserialized) {
   return null;
 }
});

Radium.RESTAdapter.map('Radium.Contact', {
  user: { key: 'assigned_to_id' }
});

Radium.RESTAdapter.map('Radium.Company', {
  user: { key: 'assigned_to_id' }
});
