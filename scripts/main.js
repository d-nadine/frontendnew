require.config({
  baseUrl: 'scripts/',
  paths: {
    jquery: 'libs/jquery/jquery',
    jqueryUI: 'libs/jquery/jquery-ui.min',
    ember: 'libs/ember/ember',
    datetime: 'libs/ember/ember-datetime',
    router: 'libs/davis',
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
  
  Radium.usersController.fetchUsers();
  Radium.contactsController.fetchContacts();
});