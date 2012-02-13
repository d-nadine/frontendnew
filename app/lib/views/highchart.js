Radium.PieChart = Ember.View.extend({
  defaults: {
    credits: {
      enabled: false
    },
    chart: {
      plotBackgroundColor: null,
      plotBorderWidth: null,
      plotShadow: false
    },
    tooltip: {
      formatter: function() {
        return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
      }
    },
    plotOptions: {
      pie: {
        allowPointSelect: true,
        cursor: 'pointer',
        dataLabels: {
          enabled: true,
          formatter: function() {
            return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
          }
        }
      }
    }
  },
  didInsertElement: function() {
    this._super();
    var target = this.$()[0];
    var title = this.get('title');
    var data = this.get('series');
    
    var options = jQuery.extend(
      this.defaults,
      {chart: {renderTo: target}},
      {title: {text: title}},
      {series: [{type: 'pie', data: data}]}
    );
    var chart = new Highcharts.Chart(options);
    this.set('chart', chart);
  },

  willDestroyElement: function() {
    var chart = this.get('chart');
    chart.destroy();
  },

  updateTitle: function() {
    var title = this.get('title'),
        chart = this.get('chart');

    if (chart) {
      chart.setTitle({text: title});
    }
  }.observes('title'),

  updateData: function() {
    var data = this.get('series'),
        chart = this.get('chart');
    if (chart) {
      chart.series[0].setData(data);
    }
  }.observes('series')
});