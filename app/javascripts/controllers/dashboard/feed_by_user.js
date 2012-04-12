Radium.feedByUserController = Crossfilter.Dimension.create({
  _byUser: function(data) {
    return data.owner.user.id;
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