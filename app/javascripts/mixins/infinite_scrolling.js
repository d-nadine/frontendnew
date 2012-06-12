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
    } else {
      Radium.LoadingManager.send('hide');
      //TODO: Use a computed property for shouldScroll?
      if(this.getPath('controller').shouldScroll()){
        $(window).on('scroll', $.proxy(self.infiniteLoading, self));
       }
    }
  }.observes('controller.isLoading') 
});
