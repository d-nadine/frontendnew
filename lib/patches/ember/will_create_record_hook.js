var get = Ember.get, set = Ember.set, isNone = Ember.isNone;
 
var coerceId = function(id) {
  return id == null ? null : id+'';
};
 
var UNLOADED = 'unloaded';
var LOADING = 'loading';
var MATERIALIZED = { materialized: true };
var CREATED = { created: true };
 
DS.Store.reopen({
createRecord: function(type, properties, transaction) {
    properties = properties || {};
 
    // Create a new instance of the model `type` and put it
    // into the specified `transaction`. If no transaction is
    // specified, the default transaction will be used.
    var record = type._create({
      store: this
    });
 
    transaction = transaction || get(this, 'defaultTransaction');
 
    // adoptRecord is an internal API that allows records to move
    // into a transaction without assertions designed for app
    // code. It is used here to ensure that regardless of new
    // restrictions on the use of the public `transaction.add()`
    // API, we will always be able to insert new records into
    // their transaction.
    transaction.adoptRecord(record);
 
    // `id` is a special property that may not be a `DS.attr`
    var id = properties.id;
 
    // If the passed properties do not include a primary key,
    // give the adapter an opportunity to generate one. Typically,
    // client-side ID generators will use something like uuid.js
    // to avoid conflicts.
 
    if (isNone(id)) {
      var adapter = this.adapterForType(type);
 
      if (adapter && adapter.generateIdForRecord) {
        id = coerceId(adapter.generateIdForRecord(this, record));
        properties.id = id;
      }
    }
 
    // Coerce ID to a string
    id = coerceId(id);
 
    // Create a new `clientId` and associate it with the
    // specified (or generated) `id`. Since we don't have
    // any data for the server yet (by definition), store
    // the sentinel value CREATED as the data for this
    // clientId. If we see this value later, we will skip
    // materialization.
    var reference = this.createReference(type, id);
    reference.data = CREATED;
 
    // Now that we have a reference, attach it to the record we
    // just created.
    set(record, '_reference', reference);
    reference.record = record;
 
    // Move the record out of its initial `empty` state into
    // the `loaded` state.
    record.loadedData();
 
    record.setupData();
 
    // Set the properties specified on the record.
    record.setProperties(properties);
 
    // Allow the adapters to implement some sort of before filters
    var adapter = this.adapterForType(type);
    adapter.willCreateRecord(type, record, transaction);
 
    // Resolve record promise
    Ember.run(record, 'resolve', record);
 
    return record;
  }
});
 
DS.Adapter.reopen({
  willCreateRecord: Ember.K()
});
