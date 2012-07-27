Radium.SCROLL_FORWARD = 1;
Radium.SCROLL_BACK = 0;
Radium.InfiniteScroller = Ember.Mixin.create({
  lastScrollTop: 0,
  init: function(){
    this._super();
    $(window).on('scroll', $.proxy(this.infiniteLoading, this));
  },
  willDestroyElement: function() {
    $(window).off('scroll');
  },
  infiniteLoading: function(e) {
    var isUp = this.isUp();

    if(isUp){
      this.set('scrollDirection', Radium.SCROLL_FORWARD);
    }else{
      this.set('scrollDirection', Radium.SCROLL_BACK);
    }

    if ((!isUp) && ($(window).scrollTop() > $(document).height() - $(window).height() - 300)) {
      this.get('controller').loadFeed({direction: Radium.SCROLL_BACK});
    }else if((isUp) && ($(window).scrollTop() < 5)){
      this.get('controller').loadFeed({direction: Radium.SCROLL_FORWARD});
    }

    return false;
  },
  isUp: function(){
    var currentScrollTop = $(window).scrollTop();

    if(currentScrollTop < 5){
      this.lastScrollTop = 0;
      return true;
    }

    var isUp = (currentScrollTop < this.lastScrollTop);

    this.lastScrollTop = currentScrollTop;

    return isUp;
  },
  isLoadingObserver: function() {
    $(window).off('scroll');

    if (this.getPath('controller.isLoading')) {

      if(this.get('scrollDirection') === Radium.SCROLL_FORWARD){
        Radium.LoadingManager.send('show');
      }else{
        Radium.LoadingManager.send('show');
      }
    } else {
      Radium.LoadingManager.send('hide');

      $(window).on('scroll', $.proxy(this.infiniteLoading, this));
    }
  }.observes('controller.isLoading')
});
