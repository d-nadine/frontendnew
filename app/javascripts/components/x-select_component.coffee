Radium.XSelectComponent = Ember.Component.extend
  click: (event) ->
    event.stopPropagation()

  init: ->
    @_super.apply this, arguments
    @on "change", this, this._updateElementValue

  _updateElementValue: ->
    @set 'checked', this.$('input').prop('checked')

  checkBoxId: Ember.computed ->
    "checker-#{@get('elementId')}"
