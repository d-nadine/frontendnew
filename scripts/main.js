require.config({
  baseUrl: 'scripts/',
  paths: {
    jquery: 'libs/jquery/jquery',
    jqueryUI: 'libs/jquery/jquery-ui',
    ember: 'libs/ember/ember',
    datetime: 'libs/ember/ember-datetime',
    router: 'libs/davis',
    highcharts: 'libs/highcharts/highcharts',
    data: 'libs/ember/ember-data',
    adapter: 'mixins/adapter',
    radium: 'core/radium',
    text: 'libs/require/require.text',
  },
  // TODO: Remove when deploying
  urlArgs: "bust=" +  (new Date()).getTime(),
  priority: [
    'jquery',
    'jqueryUI',
    'ember',
    'datetime',
    'router',
    'highcharts',
    'data',
    'adapter',
    'mixins/data',
    'radium',
    'core/app'
  ]
});

require(['core/app'], function(Radium) {
  console.log('Application started...');
  
  window.Radium = Radium;
  Radium.Routes.start();

  // FIXME: Temp fix until the datepicker registering clicks can be solved.
  $('body').on('click', 'table.ui-datepicker-calendar', function(event) {
    return false;
  });
});