Radium.NoteFormView = Ember.View.extend({
  classNames: ['well', 'form-inline'],
  contentBinding: 'parentView.content',
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
        note = Radium.store.createRecord(Radium.Note, {
          message: noteValue
        });
        
    this.getPath('content.notes').pushObject(note);

    Radium.store.commit();
    return false;
  }
});