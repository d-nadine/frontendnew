Radium.RESTAdapter = DS.RESTAdapter.extend({
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

      return this.ajax(this.url + '/me', "GET").then(function(json){
        var user = json.user;
        delete json.user;
        json.users = [user];
        Ember.run(adapter, function(){
          this.didFindQuery(store, type, json, recordArray);
        });
      });
    }else{
      base.apply(this, arguments);
    }
  }
});

Radium.RESTAdapter.configure('plurals',{
  settings: 'settings'
});

Radium.RESTAdapter.registerTransform('object', {
 deserialize: function(serialized) {
   return isNone(serialized) ? null : JSON.parse(serialized);
 },

 serialize: function(deserialized) {
   return isNone(deserialized) ? null : JSON.stringify(deserialized);
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
