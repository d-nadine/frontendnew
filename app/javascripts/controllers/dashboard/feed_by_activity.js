Radium.feedByActivityController = Crossfilter.Dimension.extend({
  _byGroupedActivity: function(data) {
    return "%@_%@".fmt(data.kind, data.tag);
  },
  kindFilterBinding: 'Radium.feedByKindController.filter',
  coffeeCupSummary: function() {
    var group = this.get('group'),
        summary = {
          todoCreated: 0,
          todoAssigned: 0,
          todoFinished: 0,
          dealCreated: 0,
          dealAssigned: 0,
          dealPending: 0,
          dealClosed: 0,
          dealPaid: 0,
          dealRejected: 0,
          dealFollowed: 0,
          campaignCreated: 0,
          campaignAssigned: 0,
          campaignContactAdded: 0,
          campaignContactRemoved: 0,
          campaignFollowed: 0,
          contactCreated: 0,
          contactAssigned: 0,
          contactBecameLead: 0,
          contactBecameProspect: 0,
          contactBecameOpportunity: 0,
          contactBecameCustomer: 0,
          contactBecameDeadEnd: 0,
          contactFollowed: 0,
          messageCreated: 0,
          meetingCreated: 0,
          meetingRescheduled: 0,
          meetingCancelled: 0,
          meetingConfirmed: 0,
          meetingRejected: 0,
          noteCreated: 0,
          phoneCallCreated: 0,
          callListCreated: 0
        };
    if (group) {
      group.all().forEach(function(item) {
        var type = Ember.String.camelize(item.key);
        summary[type] = item.value;
      });
    }
    return summary;
  }.property('group').cacheable(),
  refresh: function() {
    Ember.run.sync();
    if (this.get('kindFilter') == null) {
      this.propertyDidChange('group');
    }
  },
  crossfilterDidChange: function() {
    var cf = this.get('crossfilter'),
        dimension = cf.dimension(this._byGroupedActivity),
        group = dimension.group();
    this.setProperties({
      dimension: dimension,
      group: group
    });
  }.observes('crossfilter')
});
