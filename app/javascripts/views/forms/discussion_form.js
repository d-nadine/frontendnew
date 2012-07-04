Radium.DiscussionForm = Radium.FormView.extend({
  templateName: 'discussion_form',
  isNoteValueEmpty: true,

  discussionField: Ember.TextArea.extend({
    classNames: ['span7'],
    viewName: 'newDiscussionField',
    placeholder: "Start a new discussion",
    didInsertElement: function() {
      this.$().autosize().css('resize','none');
    },
    keyUp: function(event) {
      if (this.$().val() !== '') {
        this.setPath('parentView.isValid', true);
        this.setPath('parentView.isError', false);
        this.$().parent().removeClass('error');
      } else {
        this.setPath('parentView.isValid', false);
      }
      this._super(event);
    }
  }),

  submitForm: function(event) {
    var discussionText = this.getPath('newDiscussionField.value'),
        referenceType = this.getPath('content.type'),
        referenceId = this.getPath('content.id'),
        plural = Radium.store.adapter.pluralize(referenceType),
        discussion = Radium.store.createRecord(Radium.Note, {
          message: discussionText
        });

    // Notes are only embedded, so set as false so adapter doesn't persist
    // to /api/notes
    Radium.Note.reopenClass({
      url: false
    });

    // TODO: Re-hook up when the API is updated.
    // this.getPath('content.notes').pushObject(note);
    // this.get('content').set('notes_attributes', [note.toJSON()]);
    // Ember.run.next(function() {
    //   Radium.store.commit();
    // });

    return false;
  }
});