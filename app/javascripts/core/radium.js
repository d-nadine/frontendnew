window.Radium = Ember.Application.create({
  States: {},
  store: DS.Store.create({
    revision: 4,
    adapter: DS.RadiumAdapter.create({bulkCommit: false})
  }),
  init: function() {
    this._super();
    this.set('_api', $.cookie('user_api_key'));
  }
});

$.ajaxSetup({
  dataType: 'json',
  contentType: 'application/json',
  headers: {
    "X-Radium-User-API-Key": Radium.get('_api'),
    "Accept": "application/json"
  }
});

DS.Model.reopen({
  namingConvention: {
    keyToJSONKey: function(key) {
      return key;
    },

    foreignKey: function(key) {
      return key.toLowerCase()+"_id";
    }
  }
});
