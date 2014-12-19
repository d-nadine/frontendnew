require 'components/key_constants_mixin'

Radium.NewTagComponent = Ember.Component.extend Radium.KeyConstantsMixin,
  tagName: 'li'

  setup: Ember.on 'didInsertElement', ->
    editable = @$('.editableList')
    editable.get(0).focus()
    editable.on 'keydown', @saveOnEnter.bind(this)

  saveOnEnter: (e) ->
    return unless e.keyCode == @ENTER

    editable = @$('.editableList')

    text = $.trim(Ember.Handlebars.Utils.escapeExpression(editable.text()))

    unless text.length
      return editable.text('')

    @set 'newTag.name', text

    @sendAction 'saveTag', @get('newTag')

    false

  focusIn: (e) ->
    $('.contacts-sidebar li.active').removeClass('active')
    @$().addClass 'active'

    false

  focusOut: (e) ->
    @$().removeClass 'active'

    @get('targetObject').notifyPropertyChange 'filter'

    false
