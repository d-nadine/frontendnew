Radium.PieChartComponent = Ember.Component.extend
  initChart: (->
    console.log('hi')
    chart = dc.pieChart(@$()[0])
    @set('chart', chart)
  ).on('didInsertElement')

Ember.Handlebars.helper 'pie-chart', Radium.PieChartComponent