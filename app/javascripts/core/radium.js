window.Radium = Ember.Application.create({
  _api: null,
  store: DS.Store.create({
    revision: 4,
    adapter: DS.RadiumAdapter.create({bulkCommit: false})
  }),
  ready: function(){
  }
});

var api = $.cookie('user_api_key');
if (api) {
  Radium.set('_api', api);
}

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
