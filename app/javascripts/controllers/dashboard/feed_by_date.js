Radium.feedByDayController = Crossfilter.Dimension.create({
  _byDay: function(data) {
    return new Date(data.timestamp).getTime();
  },
  crossfilterDidChange: function() {
    var cf = this.get('crossfilter'),
        dimension = cf.dimension(this._byDay),
        group = dimension.group().all();
    this.setProperties({
      dimension: dimension,
      group: group
    });
  }.observes('crossfilter')
});