Radium.feedByUserController = Crossfilter.Dimension.create({
  _byUser: function(data) {
    return (data.user) ? data.user.id : 0;
  },
  crossfilterDidChange: function() {
    var cf = this.get('crossfilter'),
        dimension = cf.dimension(this._byUser),
        group = dimension.group().all();
    this.setProperties({
      dimension: dimension,
      group: group
    });
  }.observes('crossfilter')
});