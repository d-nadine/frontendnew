Radium.Checkbox = Ember.View.extend
  classNameBindings: ['checked:checked:unchecked', ':checker']

  click: (event) ->
    event.stopPropagation()

  init: ->
    @_super.apply this, arguments
    @on "change", this, this._updateElementValue

  _updateElementValue: ->
    @set 'checked', this.$('input').prop('checked')

  checkBoxId: (->
    "checker-#{@get('elementId')}"
  ).property()

  template: Ember.Handlebars.compile """
    <input type="checkbox" id="{{unbound view.checkBoxId}}" {{bindAttr disabled=view.disabled}}/>
    <label for="{{unbound view.checkBoxId}}" class="icon-todo"></label>
  """
