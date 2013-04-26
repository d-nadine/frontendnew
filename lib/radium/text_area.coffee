Radium.TextArea = Ember.TextArea.extend
  didInsertElement: ->
    @_super()
    @$().css 'resize', 'none'
    @$().elastic()

  willDestroyElement: ->
    @$().off('elastic')
