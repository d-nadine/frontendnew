Radium.RESTAdapter = DS.RESTAdapter.extend({
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
