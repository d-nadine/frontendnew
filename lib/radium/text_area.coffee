Radium.TextArea = Ember.TextArea.extend
  didInsertElement: ->
    @_super.apply this, arguments
    @$().css 'resize', 'none'
    @$().elastic()

  willDestroyElement: ->
    @_super.apply this, arguments
    @$().off('elastic')
