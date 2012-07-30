Radium.DatebookSectionController = Ember.ArrayController.extend({
  bootstrapLoaded: function() {
    var dateBookSection = Radium.getPath('appController.dateBookSection');

    this.set('content', dateBookSection);
  }.observes('Radium.appController.dateBookSection')
});
