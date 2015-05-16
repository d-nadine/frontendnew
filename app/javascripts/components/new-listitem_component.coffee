require 'components/key_constants_mixin'

Radium.NewListitemComponent = Ember.Component.extend Radium.KeyConstantsMixin,
  classNameBindings: [':new-listitem']

  setup: Ember.on 'didInsertElement', ->
    Ember.run.scheduleOnce 'afterRender', this, '_afterRender'

  _afterRender: ->
    editable = @$('.editableList')
    @newItemFocus()
    editable.on 'keydown', @saveOnEnter.bind(this)

    cancel = Ember.run.later =>
      Ember.run.cancel cancel
      @$().removeClass 'new-listitem'
    , 1500

  saveOnEnter: (e) ->
    return unless e.keyCode == @ENTER

    editable = @$('.editableList')

    text = $.trim(Ember.Handlebars.Utils.escapeExpression(editable.text()))

    unless text.length
      return editable.text('')

    listItem = @get('listItem')

    if listItem.set
      listItem.set 'name', text
    else
      listItem.name = text

    @sendAction "action", listItem

    false

  click: (e) ->
    @newItemFocus()

    e.stopPropagation()
    e.preventDefault()

    false

  newItemFocus: ->
    $('.contacts-sidebar li.active').removeClass('active')
    @$().addClass 'active'
    @$('.editableList').focus()

    false

  focusOut: (e) ->
    @$().removeClass 'active'

    @get('targetObject').notifyPropertyChange 'filter'

    false
