Radium.PageScroller = Ember.Mixin.create(Ember.Evented, {
  page: 1,
  canScroll: true,
  content: Ember.A(),
  shouldScroll: function(scrollData){
    if(scrollData.direction === Radium.SCROLL_FORWARD){
      return false;
    }

    return this.get('canScroll');
  },
  loadFeed: function(scrollData, options){
    if(!this.get('canScroll')){
      return;
    }

    var url = '%@?page=%@'.fmt(options.url, this.get('page'));

    var self = this;

    this.set('isLoading', true);

    get = $.getJSON(url);

    get.success(function(data){
      self.set('page', data.meta.pagination.current + 1);
      self.set('canScroll', (self.get('page') <= data.meta.pagination.total));
      
      var resources = data[options.resource]

      if(!resources || resources.length === 0){
        return;
      }

      Radium.store.loadMany(options.dataType, resources);

      var entities = Radium.store.findMany(options.dataType, resources.mapProperty('id').uniq());

      if(self.getPath('content.length') === 0){
        self.set('content', entities);
      }else{
        self.get('content').pushObjects(entities);
      }

      self.set('isLoading', false);
    });

    //TODO: What are we doing with errors
    get.error(function(response){
      self.set('isLoading', false);
      console.error(response.responseText);
    })
  }
});
