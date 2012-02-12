minispade.require.config({
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
    text: 'libs/minispade.require/minispade.require.text',
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

minispade.require(['core/app'], function(Radium) {
  console.log('Application started...');
  
  window.Radium = Radium;
  Radium.Routes.start();

  // FIXME: Temp fix until the datepicker registering clicks can be solved.
  $('body').on('click', 'table.ui-datepicker-calendar', function(event) {
    return false;
  });
});
minispade.require('radium/libs/jquery/jquery')
minispade.require('radium/libs/jquery-ui');
minispade.require('radium/libs/ember/ember');
minispade.require('radium/libs/ember/ember-datetime');
minispade.require('radium/libs/ember/ember-data');
minispade.require('radium/libs/davis');
minispade.require('radium/libs/highcharts/highcharts');

minispade.require('radium/helpers/date_helper');
minispade.require('radium/helpers/time_helper');

minispade.require('radium/mixins/jqueryui');


minispade.require('radium/controllers/feed');
minispade.require('radium/controllers/announcements');
minispade.require('radium/controllers/app');
minispade.require('radium/controllers/users');
minispade.require('radium/controllers/contacts');
minispade.require('radium/controllers/everyone');
minispade.require('radium/controllers/resources');
minispade.require('radium/controllers/dashboard');
minispade.require('radium/controllers/activity_date_groups');
minispade.require('radium/controllers/deals');

minispade.require('radium/models/core');
minispade.require('radium/models/comment');
minispade.require('radium/models/address');
minispade.require('radium/models/announcement');
minispade.require('radium/models/attachment');
minispade.require('radium/models/calllist');
minispade.require('radium/models/campaign');
minispade.require('radium/models/customfield');
minispade.require('radium/models/deal');
minispade.require('radium/models/email');
minispade.require('radium/models/emailaddr');
minispade.require('radium/models/following');
minispade.require('radium/models/group');
minispade.require('radium/models/im');
minispade.require('radium/models/invitation');
minispade.require('radium/models/lineitem');
minispade.require('radium/models/meeting');
minispade.require('radium/models/message');
minispade.require('radium/models/note');
minispade.require('radium/models/phonecall');
minispade.require('radium/models/phonenumber');
minispade.require('radium/models/product');
minispade.require('radium/models/reminder');
minispade.require('radium/models/sms');
minispade.require('radium/models/todo');
minispade.require('radium/models/contact');
minispade.require('radium/models/user');
minispade.require('radium/models/activity');
minispade.require('radium/models/activity_date_group');

minispade.require('radium/fixtures/main');

minispade.require('radium/views/highchart');
minispade.require('radium/views/forms/form');
minispade.require('radium/views/forms/textfield');
minispade.require('radium/views/checkbox');
minispade.require('radium/views/forms/datepicker');
minispade.require('radium/views/forms/autocomplete');
minispade.require('radium/views/topbar');2
minispade.require('radium/views/forms/todo_form');
minispade.require('radium/views/forms/message_form');
minispade.require('radium/views/forms/discussion_form');
minispade.require('radium/views/forms/call_list_form');
minispade.require('radium/views/forms/meeting_form');
minispade.require('radium/views/forms/deal_form');
minispade.require('radium/views/forms/todo_form');
minispade.require('radium/views/dashboard');
minispade.require('radium/views/deals/deals');
minispade.require('radium/views/filter_list');
minispade.require('radium/views/globalsearch');
minispade.require('radium/views/loginpane');
minispade.require('radium/views/profile');
minispade.require('radium/views/dashboard/activity_summary');

minispade.require('radium/states/main');

minispade.require('radium/core/routes');