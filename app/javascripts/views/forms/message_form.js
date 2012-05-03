Radium.MessageForm = Radium.FormView.extend({
  templateName: 'message_form',

  isOptionalVisible: false,
  toggleText: function() {
    return (this.get('isOptionalVisible')) ? 'Hide' : 'Show';
  }.property('isOptionalVisible').cacheable(),
  toggleOptional: function() {
    this.toggleProperty('isOptionalVisible');
    return false;
  },
  messageOptionalFields: Ember.View.extend({
    isVisibleBinding: 'parentView.isOptionalVisible',
    willClearFields: function() {
      if (!this.get('isVisible')) {
        this.$('input:text').val('');
      }
    }.observes('isVisible')
  }),

  isAttachmentVisible: false,
  toggleAttachmentText: function() {
    return (this.get('isAttachmentVisible')) ? 'Remove' : 'Add';
  }.property('isAttachmentVisible').cacheable(),
  toggleAttachment: function() {
    this.toggleProperty('isAttachmentVisible');
    return false;
  },
  attachmentField: Ember.View.extend({
    isVisibleBinding: 'parentView.isAttachmentVisible',
    willClearFields: function() {
      if (!this.get('isVisible')) {
        this.$('input:file').val('');
      }
    }.observes('isVisible')
  })
});