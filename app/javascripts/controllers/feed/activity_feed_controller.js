//TODO rename to ClusterFeedController
Radium.ActivityFeedController = Ember.ArrayProxy.extend(Radium.BatchViewLoader, {
  content: Ember.A(),
  init: function(){
    this._super();
    this.set('view', Ember.ContainerView.create());
  },
  shouldScroll: function(){
    this.set('start_date', Ember.DateTime.parse(Radium.getPath('appController.current_user.meta.feed.start_date'), '%Y-%m-%d'));
    this.set('end_date', Ember.DateTime.parse(Radium.getPath('appController.current_user.meta.feed.end_date'), '%Y-%m-%d'));

    if(!this.get('current_date')){
      this.set('current_date', Ember.DateTime.parse(Radium.getPath('appController.current_user.meta.feed.current_date'), '%Y-%m-%d'));
    }

    var diffDays = Ember.DateTime.DifferenceInDays(this.get('end_date'), this.get('current_date'));
    
    return (diffDays > 1);
  },

  loadFeed: function(){
    this.set('isLoading', true);
    
    var date = this.get('current_date').toFormattedString('%Y-%m-%d');

    var url = '/api/users/%@/feed?start_date=%@&end_date=%@'.fmt(Radium.getPath('appController.current_user.id'), date, date);
    
    var self = this;

    //TODO: Should we have a cluster ember-data model?
    $.when($.ajax(jQuery.extend({url: url}, CONFIG.ajax))).then(function(data){
      if(data.feed.clusters.length > 0){
        self.get('content').pushObjects(data.feed.clusters.map(function(data) { return Ember.Object.create(data); }));
      }

      if(data.feed.activities.length > 0){
        Radium.store.loadMany(Radium.Activity, data.feed.activities);
      }

      self.set('current_date', self.get('current_date').advance({day: 1}));
      self.set('isLoading', false);
    }).fail(function(){
      self.set('isLoading', false);
    });
  },

  bootstrapLoaded: function(){
    var clusters = Radium.getPath('appController.clusters');

    if (clusters) {
      this.set('content', clusters);
    }
  }.observes('Radium.appController.clusters')
});
