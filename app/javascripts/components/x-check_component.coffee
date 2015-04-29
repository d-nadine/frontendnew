Radium.XCheckComponent = Ember.Component.extend
  click: (event) ->
    event.stopPropagation()

    Ember.run.schedule('actions', this, 'sendNotification')

  sendNotification: ->
    @sendAction('sendCheck')

  init: ->
    @_super.apply this, arguments
    @on "change", this, this._updateElementValue

  setup: Ember.on 'didInsertElement', ->
    this.$('input').prop('checked', !!this.get('checked'))

  _updateElementValue: ->
    @set 'checked', this.$('input').prop('checked')

  checkBoxId: Ember.computed ->
    "checker-#{@get('elementId')}"
