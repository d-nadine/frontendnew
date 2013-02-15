Radium.FormsCheckboxView = Ember.View.extend
  checkedBinding: 'controller.isFinished'
  disabled: (->
    @get('controller.isDisabled') || @get('controller.isNew')
  ).property('controller.isDisabled', 'controller.isNew')

  click: (event) ->
    event.stopPropagation()

  init: ->
    @_super.apply this, arguments
    @on "change", this, this._updateElementValue

  _updateElementValue: ->
    @set 'checked', this.$('input').prop('checked')

  classNames: ['checker']
  tabindex: 4
  checkBoxId: (->
    "checker-#{@get('elementId')}"
  ).property()

  template: Ember.Handlebars.compile """
    <input type="checkbox" id="{{unbound view.checkBoxId}}" {{bindAttr disabled=view.disabled}}/>
    <label for="{{unbound view.checkBoxId}}"></label>
  """
