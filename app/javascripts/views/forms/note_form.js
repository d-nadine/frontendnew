Radium.NoteFormView = Ember.View.extend({
  classNames: ['well', 'form-inline'],
  templateName: 'note_form',
  isNoteValueEmpty: true,

  noteField: Ember.TextArea.extend({
    classNames: ['span7'],
    viewName: 'newNoteField',
    keyUp: function(event) {
      this._super(event);
      if (this.get('value')) {
        this.setPath('parentView.isNoteValueEmpty', false);
      } else {
        this.setPath('parentView.isNoteValueEmpty', true);
      }
    }
  }),

  addNote: function(event) {
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
    
    Ember.run.next(function() {
      Radium.store.commit();
    });

    return false;
  }
});