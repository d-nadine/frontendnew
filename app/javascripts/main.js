minispade.require('jquery');
minispade.require('jquery-ui');
minispade.require('jquery-cookie');
minispade.require('davis');
minispade.require('ember');
minispade.require('ember-datetime');
minispade.require('ember-data');
minispade.require('date-utils');
minispade.require('highcharts');
minispade.require('crossfilter');
minispade.require('bootstrap-tooltip');

CONFIG.api = $.cookie('user_api_key');

$.ajaxSetup({
  dataType: 'json',
  contentType: 'application/json',
  headers: {
    "X-Radium-User-API-Key": CONFIG.api,
    "Accept": "application/json"
  }
});

minispade.require('radium/adapters/main');
minispade.require('radium/core/radium');
minispade.require('radium/mixins/main');
minispade.require('radium/helpers/main');
minispade.require('radium/crossfilter/main')
minispade.require('radium/models/main')
minispade.require('radium/controllers/main');
minispade.require('radium/views/main');
minispade.require('radium/states/main');
minispade.require('radium/templates/main');
minispade.require('radium/core/routes');

$(document).ready(function() {
  var app = Davis(Radium.Routes);
  app.start();

  // FIXME: Temp fix until the datepicker registering clicks can be solved.
  $('body').on('click', 'table.ui-datepicker-calendar', function(event) {
    return false;
  });
});
