Radium.XCheckComponent = Ember.Component.extend
  click: (event) ->
    event.stopPropagation()

    Ember.run.schedule('actions', this, 'sendNotification')

  sendNotification: ->
    @sendAction('action')

    false

  init: ->
    @_super.apply this, arguments
    @on "change", this, this._updateElementValue

  setup: Ember.on 'didInsertElement', ->
    this.$('input').prop('checked', !!this.get('checked'))

  teardown: Ember.on 'willDestroyElement', ->
    @off "change"

  _updateElementValue: ->
    @set 'checked', this.$('input').prop('checked')
    false

  checkBoxId: Ember.computed ->
    "checker-#{@get('elementId')}"
