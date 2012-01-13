define('core/adapter', function(require) {
  require('ember');
  require('data');
  var adapter;

  adapter = DS.RESTAdapter.extend({
    plurals: {
      address: "addresses"
    }
  });

  return adapter;
});