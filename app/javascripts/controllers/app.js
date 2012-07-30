Radium.AppController = Ember.Object.extend({
  sideBarView: null,
  feedView: null,
  // During development set to true
  isLoggedIn: true,
  // Store the routes intercepted by Davis
  _statePathCache: {},
  currentPage: null,
  selectedForm: null,
  params: null,
  account: null,
  timezone: new Date().getTimezoneOffset(),
  formContainerView: null,
  getFeedUrl: function(resource, id, start, end){
    if(arguments.length < 3){
      return '/api/%@/%@/feed'.fmt(resource, id);
    }

    var endDate = (arguments.length === 3) ? start : end;
    return '/api/%@/%@/feed?start_date=%@&end_date=%@'.fmt(resource, id, start, endDate);
  },
  toggleKind: function(){
    var kind = this.get('filter');
    var speed = 'fast';

    var types = $('.meeting,.todo,.deal,.call_list,.campaign,.contact,.invitation,.phone_call');

    if(!kind){
      types.slideDown(speed);
      return false;
    }

    var className = '.' + kind;

    $(types).not(className).slideUp(speed, function(){
      $(className).slideDown(speed);
    });
  },
  bootstrap: function(data){
    var dateBookSection =  Radium.Utils.loadDateBook(data.feed.datebook_section),
        bootstrapDate = Ember.DateTime.parse(data.feed.start_date, '%Y-%m-%d'),
        checkDate = Ember.DateTime.compareDate(bootstrapDate, this.get('today'));

    if (checkDate === 0) {
      this.set('isTodayBootstrapped', true);
    }

    Radium.store.load(Radium.Account, data.account);
    var account = Radium.store.find(Radium.Account, data.account.id),
        clusters = [];

    Radium.store.loadMany(Radium.Notification, data.notifications);
    var notifications = Radium.store.findMany(Radium.Notification, data.notifications.mapProperty('id').uniq());

    //kick off observers
    this.set('bootstrapDate', bootstrapDate);
    this.set('account', account);
    this.set('users', data.users);
    this.set('current_user', data.current_user);
    this.set('dateBookSection', dateBookSection);
    this.set('clusters', data.feed.historical_section.clusters.map(function(data) { return Ember.Object.create(data); }));
    this.set('contacts', data.contacts);
    this.set('feed', data.feed);
    // Can set a mutable controller with findMany, I'm afraid
    this.set('notifications', notifications.map(function(item) {return item;}));
  },

  today: Ember.DateTime.create({hour: 17, minute: 0, second: 0}),
  todayString: function() {
    return this.get('today').toFormattedString("%Y-%m-%d");
  }.property('today').cacheable()
});
