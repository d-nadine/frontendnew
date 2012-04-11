Radium.CrossfilterView = Ember.Mixin.create({
  filter: null,
  dimension: null,
  group: null,
  applyFilter: function() {
    var filter = this.get('filter'),
        dimension = this.get('dimension');
    dimension.filter(filter);
  }.observes('filter')
});