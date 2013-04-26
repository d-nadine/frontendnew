Radium.TextArea = Ember.TextArea.extend
  classNameBindings: ['field']
  didInsertElement: ->
    @_super()
    @$().css 'resize', 'none'
    @$().elastic()

  willDestroyElement: ->
    @$().off('elastic')
