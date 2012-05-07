Radium.LeadView = Radium.FeedView.extend({
  templateName: 'lead',
  classNames: ['feed-item', 'contact-lead'],
  isReassigning: null,
  reassign: function(event) {
    this.toggleProperty('isReassigning');
    return false;
  },
  userSelect: Ember.Select.extend({
    didInsertElement: function() {
      var self = this;
      this.$().focus();
      $('html').on('click.namespace', function() {
        self.setPath('parentView.isReassigning', false);
      });
    },
    willDestroyElement: function() {
      $('html').off('click.namespace');
    },
    keyUp: function(event) {
      if (event.keyCode === 27) {
        this.setPath('parentView.isReassigning', false);
      }
    },
    contentBinding: 'Radium.usersController.content',
    optionLabelPath: 'content.name',
    optionValuePath: 'content.id',
    selectionBinding: 'parentView.content.user',
    assignmentDidChange: function() {
      console.log(this.get('value'));
    }.observes('value')
  })
});