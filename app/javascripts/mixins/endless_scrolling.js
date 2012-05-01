Radium.EndlessScrolling = Ember.Mixin.create({

  didInsertElement: function() {
    this._super();
    this.loadFeed();
  },

  willDestroyElement: function() {
    $(window).off('scroll');
  },

  infiniteLoading: function() {
    if ($(window).scrollTop() > $(document).height() - $(window).height() - 300) {
      this.loadFeed();
      return false;
    }
  },

  loadFeed: function() {
    $(window).off('scroll');
    // View Settings
    var feed = this.get('feed'),
        feedUrl = this.get('feedUrl'),
        targetId = this.get('targetId');

    // Local variables
    var self = this,
        page = this.get('page'),
        today = Radium.appController.get('today'),
        oneWeekAgo = today.adjust({day: today.get('day') - 7});

    if (this.get('page') < this.get('totalPages')) {
      Ember.run.next(function() {
        Radium.App.goToState('loading');
      });

      var data = {
            url: feedUrl.fmt(targetId),
            type: 'GET',
            data: {page: (page+1), before: today.toISO8601()}
          },
          request = jQuery.extend(data, CONFIG.ajax);

      $.ajax(request)
        .success(function(data, status, xhr) {
          var totalPages = xhr.getResponseHeader('x-radium-total-pages'),
              currentPage = xhr.getResponseHeader('x-radium-current-page');

          self.setProperties({
            totalPages: parseInt(totalPages),
            page: parseInt(currentPage)
          });

          data.activities.forEach(function(activity) {
            // Set some properties for view's to distingushed old items from
            // pushed new items.
            activity.isNewActivity = false;
            activity.isCached = false;
            feed.add(activity);
          });
          Ember.run.next(function() {
            Radium.App.goToState('ready');
          });

          // self.bindToScroll();
          $(window).on('scroll', $.proxy(self.infiniteLoading, self));
        })
        .error(function() {
          $(window).off('scroll');
          Radium.App.set('isEmptyFeed', true);
          Radium.App.goToState('ready');
        });
    } else {
      $(window).off('scroll');
    }
  }
});
