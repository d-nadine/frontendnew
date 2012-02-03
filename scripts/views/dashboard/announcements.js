define('views/dashboard/announcements', function(require) {
  
  var Radium = require('radium'),
      template = require('text!templates/dashboard/announcements.handlebars');

  Radium.AnnouncementsView = Ember.View.extend({
    classNames: 'span12'.w(),
    notificationsCollectionView: Ember.CollectionView.extend({
      contentBinding: 'Radium.announcementsController',
      itemViewClass: Ember.View.extend({
        viewUser: function(event) {
          console.log('would go to user', this.getPath('content.user.id'));
          return false;
        },
        dismiss: function() {
          this.$().fadeOut('fast');
          return false;
        },
        classNames: 'notification'.w()
      })
    }),
    template: Ember.Handlebars.compile(template)
  });

  return Radium;
});