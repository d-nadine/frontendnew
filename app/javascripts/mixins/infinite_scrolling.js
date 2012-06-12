Radium.InfiniteScroller = Ember.Mixin.create({
  willDestroyElement: function() {
    $(window).off('scroll');
  },
  infiniteLoading: function() {
    if ($(window).scrollTop() > $(document).height() - $(window).height() - 300) {
      this.get('controller').loadFeed();
      return false;
    }
  },
  isLoadingObserver: function() {
    var self = this;
    if (this.getPath('controller.isLoading')) {
      $(window).off('scroll');
      Radium.LoadingManager.send('show');
      if($('.feed-cluster:last').length === 1){
        this.set('lastCluster', $('.feed-cluster:last').offset().top);
      }
    } else {
      Radium.LoadingManager.send('hide');

      if(self.getPath('controller.foundData')){
        if(this.get('lastCluster')){
          // $('html,body').animate({
          //   scrollTop: self.get('lastCluster')
          // }, 2000);
          this.set('lastCluster', null);
        }
      }

      //TODO: Use a computed property for shouldScroll?
      if(this.getPath('controller').shouldScroll()){
        $(window).on('scroll', $.proxy(self.infiniteLoading, self));
       }
    }
  }.observes('controller.isLoading') 
});
