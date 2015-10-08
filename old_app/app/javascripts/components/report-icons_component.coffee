Radium.ReportIconsComponent = Ember.Component.extend
  icon: "user"
  iconCountArray: Ember.computed 'total', ->
    Array(@get('total') || 0)
