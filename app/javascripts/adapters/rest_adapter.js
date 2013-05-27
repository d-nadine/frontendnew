Radium.RESTAdapter = DS.RESTAdapter.extend({
  createRecord: function(store, type, record) {
    if(type == Radium.CurentUser) return;

    this._super.apply(this, arguments);
  }
});

Radium.RESTAdapter.configure('plurals',{
  settings: 'settings',
  company: 'companies'
});

Radium.RESTAdapter.registerTransform('object', {
 deserialize: function(serialized) {
   return serialized;
 },

 serialize: function(deserialized) {
   return Ember.isNone(deserialized) ? null : JSON.stringify(deserialized);
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
