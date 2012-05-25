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

  isFirstRun: true,
  noData: false,

  isLoadingObserver: function() {
    var self = this;
    if (this.getPath('controller.isLoading')) {
      $(window).off('scroll');
    } else {
      $(window).on('scroll', $.proxy(self.infiniteLoading, self));
    }
  }.observes('controller.isLoading'),

  loadFeed: function() {
    this.get('controller').loadDates();
  },

  // loadFeed: function() {
  //   $(window).off('scroll');
  //   // View Settings
  //   var feed = this.get('feed'),
  //       feedUrl = this.get('feedUrl'),
  //       accountCreatedAtDate = Radium.accountController.get('accountCreatedAt'),
  //       targetId = Radium.appController.get('params') 
  //                 || Radium.usersController.getPath('loggedInUser.id');

  //   // Local variables
  //   var self = this,
  //       endDate = this.get('newestDateLoaded') || Radium.appController.get('today'),
  //       endDate = endDate.advance({day: -1}),
  //       startDate = endDate.adjust({day: endDate.get('day') - 2});

  //   if (Ember.DateTime.compare(startDate, accountCreatedAtDate) === 1) {
  //     Ember.run.next(function() {
  //       Radium.App.goToState('loading');
  //     });

  //     var data = {
  //           url: feedUrl.fmt(targetId),
  //           type: 'GET',
  //           data: {
  //             end_date: endDate.toFormattedString('%Y-%m-%d'), 
  //             start_date: startDate.toFormattedString('%Y-%m-%d')
  //           }
  //         },
  //         request = jQuery.extend(data, CONFIG.ajax);

  //     $.ajax(request)
  //       .success(function(data, status, xhr) {

  //         // test to make sure the feed isn't empty on first load
  //         var keys = Ember.keys(data);
  //         if (self.get('isFirstRun') && !data[keys[0]].length) {
  //           self.set('noData', true);
  //         } else {
  //           self.set('isFirstRun', false);
  //           self.set('noData', false);
  //         }

  //         self.setProperties({
  //           oldestDateLoaded: endDate,
  //           newestDateLoaded: startDate
  //         });

  //         data.activities.forEach(function(activity) {
  //           // Set some properties for view's to distingushed old items from
  //           // pushed new items.
  //           activity.isNewActivity = false;
  //           activity.isCached = false;
  //           feed.add(activity);
  //         });

  //         Ember.run.next(function() {
  //           Radium.App.goToState('ready');
  //         });

  //         // self.bindToScroll();
  //         $(window).on('scroll', $.proxy(self.infiniteLoading, self));
  //       })
  //       .error(function(jqXHR, textStatus, errorThrown) {
  //         $(window).off('scroll');
  //         Radium.App.set('isEmptyFeed', true);
  //         Radium.App.goToState('ready');
  //         Radium.ErrorManager.send('displayError', {
  //           status: jqXHR.status,
  //           responseText: jqXHR.responseText
  //         });
  //       });
  //   } else {
  //     $(window).off('scroll');
  //   }
  // }
});
