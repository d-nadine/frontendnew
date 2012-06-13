Radium.feedByContactController = Crossfilter.Dimension.extend({
  _byContact: function(data) {
   return (data.contact) ? data.contact.id : 0;
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
