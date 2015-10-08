Radium.FormBoxView = Ember.View.extend
  focusField: (->
    unless 'ontouchstart' of window
      Ember.run.schedule('afterRender', this, ->
        @$('textarea').focus()
      )
  ).on('didInsertElement')