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

      //TODO: Animate to date header
      // if(self.getPath('controller.foundData')){
      //   if($('.date-header:last').length === 1){
      //     $('html,body').animate({
      //       scrollTop: $('.date-header:last').offset().top
      //     }, 2000);
      //   }
      // }

      if(this.getPath('controller').shouldScroll()){
        $(window).on('scroll', $.proxy(self.infiniteLoading, self));
       }
    }
  }.observes('controller.isLoading') 
});
