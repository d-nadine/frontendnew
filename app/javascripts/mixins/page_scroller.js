Radium.PageScroller = Ember.Mixin.create(Ember.Evented, {
  page: 1,
  canScroll: true,
  shouldScroll: function(scrollData){
    if(scrollData.direction === Radium.SCROLL_FORWARD){
      return false;
    }

    return this.get('canScroll');
  },
  loadFeed: function(scrollData){
    if(!this.get('canScroll')){
      return;
    }

    var options = this.get('scrollOptions');

    var url = '%@?page=%@'.fmt(options.url, this.get('page'));

    var self = this;

    this.set('isLoading', true);

    get = $.getJSON(url);

    get.success(function(data){
      self.set('page', data.meta.pagination.current + 1);
      self.set('canScroll', (self.get('page') <= data.meta.pagination.total));
      
      var resources = data[options.resource]

      if(!resources || resources.length === 0){
        self.set('canScroll', false);
        return;
      }

      Radium.store.loadMany(options.dataType, resources);

      var entities = Radium.store.findMany(options.dataType, resources.mapProperty('id').uniq());

      entities.forEach(function(entity){
        Radium.getPath(options.contentPath).pushObject(entity);
      });

      self.set('isLoading', false);
    });

    //TODO: What are we doing with errors
    get.error(function(response){
      self.set('isLoading', false);
      console.error(response.responseText);
    })
  }
});
