Radium.FormBoxView = Ember.View.extend
  focusField: (->
    Ember.run.schedule('afterRender', this, ->
      @$('textarea').focus()
    )
  ).on('didInsertElement')