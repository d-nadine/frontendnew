minispade.require('radium/libs/jquery/jquery');
minispade.require('radium/libs/jquery/jquery-ui');
minispade.require('radium/libs/ember/ember');
minispade.require('radium/libs/ember/ember-datetime');
minispade.require('radium/libs/ember/ember-data');
minispade.require('radium/libs/davis');
minispade.require('radium/libs/highcharts/highcharts');
minispade.require('radium/mixins/jqueryui');
minispade.require('radium/adapters/main');
minispade.require('radium/core/radium');
minispade.require('radium/helpers/main');

minispade.require('radium/models/main')
minispade.require('radium/controllers/main');
minispade.require('radium/views/main')
minispade.require('radium/fixtures/main');
minispade.require('radium/core/routes');
minispade.require('radium/states/main');

// FIXME: Temp fix until the datepicker registering clicks can be solved.
$('body').on('click', 'table.ui-datepicker-calendar', function(event) {
  return false;
});