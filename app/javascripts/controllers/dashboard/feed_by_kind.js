Radium.feedByKindController = Crossfilter.Dimension.create({
  _byKind: function(data) {
    return data.kind;
  },
  crossfilterDidChange: function() {
    var cf = this.get('crossfilter'),
        dimension = cf.dimension(this._byKind),
        group = dimension.group().all();
    this.setProperties({
      dimension: dimension,
      group: group
    });
  }.observes('crossfilter')
});