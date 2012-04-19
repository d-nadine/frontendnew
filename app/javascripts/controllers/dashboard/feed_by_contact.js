Radium.feedByContactController = Crossfilter.Dimension.create({
  _byContact: function(data) {
    if (data.reference.contact) {
      return data.reference.contact.id;
    } else {
      return 0;
    }
  },
  crossfilterDidChange: function() {
    var cf = this.get('crossfilter'),
        dimension = cf.dimension(this._byContact),
        group = dimension.group().all();
    this.setProperties({
      dimension: dimension,
      group: group
    });
  }.observes('crossfilter')
});