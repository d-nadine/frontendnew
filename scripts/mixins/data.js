define('mixins/data', function(require) {
  require('ember');
  require('data');
  
  DS.attr.transforms.array = {
    from: function(serialized) {
      return serialized;
    },
    to: function(deseralized) {
      return deserialized;
    }
  };
});