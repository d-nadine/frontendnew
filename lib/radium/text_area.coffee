Radium.TextArea = Ember.TextArea.extend
  didInsertElement: ->
    @_super()
    @$().elastic()

  willDestroyElement: ->
    @$().off('elastic')
