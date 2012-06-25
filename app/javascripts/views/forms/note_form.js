Radium.NoteForm = Radium.FormView.extend({
  templateName: 'note_form',
  isNoteValueEmpty: true,

  noteField: Ember.TextArea.extend({
    classNames: ['span7'],
    viewName: 'newNoteField',
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
    var noteValue = this.getPath('newNoteField.value'),
        referenceType = this.getPath('content.type'),
        referenceId = this.getPath('content.id'),
        plural = Radium.store.adapter.pluralize(referenceType),
        note = Radium.store.createRecord(Radium.Note, {
          message: noteValue
        });

    // Notes are only embedded, so set as false so adapter doesn't persist
    // to /api/notes
    Radium.Note.reopenClass({
      url: false
    });

    this.getPath('content.notes').pushObject(note);
    this.get('content').set('notes_attributes', [note.toJSON()]);
    
    this.setPath('newNoteField.value', null);
    this.getPath('parentView.childViews').removeObject(this)

    // TODO: Re-hook up when the API is updated.
    // Ember.run.next(function() {
    //   Radium.store.commit();
    // });

    return false;
  }
});