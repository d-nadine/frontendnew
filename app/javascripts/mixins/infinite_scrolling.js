Radium.SCROLL_FORWARD = 1;
Radium.SCROLL_BACK = 0;
Radium.InfiniteScroller = Ember.Mixin.create({
  lastScrollTop: 0,

  willDestroyElement: function() {
    $(window).off('scroll');
  },
  infiniteLoading: function(e) {
    var isUp = this.isUp()
    if ((!isUp) && ($(window).scrollTop() > $(document).height() - $(window).height() - 300)) {
      this.get('controller').loadFeed({direction: Radium.SCROLL_BACK});
      return false;
    }else if((isUp) && ($(window).scrollTop() < 5)){
      this.get('controller').loadFeed({direction: Radium.SCROLL_FORWARD});
    }
  },
  isUp: function(){
    var currentScrollTop = $(window).scrollTop();

    var isUp = (currentScrollTop < this.lastScrollTop);

    this.lastScrollTop = currentScrollTop;

    return isUp;
  },
  isLoadingObserver: function() {
    var self = this;
    if (this.getPath('controller.isLoading')) {
      $(window).off('scroll');
      
      Radium.LoadingManager.send('show');
    } else {
      Radium.LoadingManager.send('hide');

      $(window).on('scroll', $.proxy(self.infiniteLoading, self));
    }
  }.observes('controller.isLoading') 
});
