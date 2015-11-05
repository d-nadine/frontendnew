DS.Model.reopenClass({
  humanize: function() {
    return this.toString().humanize();
  },
  instanceFromHash: function(hash, key, type, store) {
    const id = hash[key]["id"];
    const adapter = store.adapterForType(type);

    adapter.didFindRecord(store, type, hash, id);

    return type.find(id);
  }
});

DS.Model.reopen({
  humanize: function() {
    return this.constructor.humanize();
  }
});
