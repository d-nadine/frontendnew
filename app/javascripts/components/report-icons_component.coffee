Radium.ReportIconsComponent = Ember.Component.extend
  icon: "user"
  iconCountArray: ( ->
    Array(@get('total') || 0)
  ).property('total')