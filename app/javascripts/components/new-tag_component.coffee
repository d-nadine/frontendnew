require 'components/key_constants_mixin'

Radium.NewTagComponent = Ember.Component.extend Radium.KeyConstantsMixin,
  tagName: 'li'
  isCurrent: true
  classNameBindings: ['isCurrent:active']

  setup: Ember.on 'didInsertElement', ->
    $('.contacts-sidebar li.active').removeClass('active')

    Ember.run.next =>
      @set 'isCurrent', true

    editable = @$('.editableList')
    editable.get(0).focus()
    editable.on 'focus', @focusEditable.bind(this)
    editable.on 'keydown', @saveOnEnter.bind(this)

  saveOnEnter: (e) ->
    return unless e.keyCode == @ENTER

    editable = @$('.editableList')

    text = $.trim(Ember.Handlebars.Utils.escapeExpression(editable.text()))

    unless text.length
      return editable.text('')

    @set 'newTag.name', text

    @sendAction 'saveTag', @get('newTag')

  focusEditable: (e) ->
    false

  # focusOut: (e) ->
  #   p "in focusOut"
  #   @set 'isCurrent', false
