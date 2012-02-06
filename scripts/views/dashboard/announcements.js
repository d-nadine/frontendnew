define('views/dashboard/announcements', function(require) {
  
  var Radium = require('radium'),
      template = require('text!templates/dashboard/announcements.handlebars');

  Radium.AnnouncementsView = Ember.View.extend({
    classNames: 'span12'.w(),
    isVisible: function() {
      var arr = Radium.announcementsController.get('length');
      return (arr > 0) ? true : false;
    }.property('Radium.announcementsController.length').cacheable(),
    notificationsCollectionView: Ember.CollectionView.extend({
      contentBinding: 'Radium.announcementsController',
      itemViewClass: Ember.View.extend({
        viewUser: function(event) {
          console.log('would go to user', this.getPath('content.user.id'));
          return false;
        },
        dismiss: function() {
          var self = this,
              $this = this.$(),
              idx = this.get('contentIndex');
          $this.fadeOut('fast', function() {
            Radium.announcementsController.removeAt(idx);
          });
          return false;
        },
        classNames: 'notification'.w()
      })
    }),
    template: Ember.Handlebars.compile(template)
  });

  return Radium;
});