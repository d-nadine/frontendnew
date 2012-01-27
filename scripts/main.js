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

  Radium.TestView = Ember.View.extend({
    contentBinding: 'Radium.feedController.content',
    test: function() {
      var content = this.get('content'),
          date = this.get('date');
          console.log(date.toString(), content.getEach('day'), content.filterProperty('day', date));
      return content.filterProperty('day', date.toString());
    }.property('date').cacheable()
  });

  Radium.store.loadMany(Radium.Activity, [
        {id: 100, timestamp: "2012-01-12T14:26:27Z", title: "my test title 1"},
        {id: 101, timestamp: "2012-01-12T14:26:27Z", title: "my test title 2"},
        {id: 102, timestamp: "2012-05-08T14:26:27Z", title: "my test title 3"},
        {id: 103, timestamp: "2012-07-30T14:26:27Z", title: "my test title 4"},
        {id: 104, timestamp: "2012-08-17T14:26:27Z", title: "my test title 5"},
        {id: 105, timestamp: "2011-12-04T14:26:27Z", title: "my test title 6"}
      ]);

  Radium.feedController.set('content', Radium.store.findAll(Radium.Activity));

  // var test = Radium.store.findAll(Radium.Activity);

  Radium.usersController.fetchUsers();
  // Radium.contactsController.fetchContacts();
  // var test = [
  //   Ember.Object.create({date: "2011", activities: test}),
  //   Ember.Object.create({date: "2012", activities: test})
  // ];
  // Radium.feedController.set('sorted', test);
});