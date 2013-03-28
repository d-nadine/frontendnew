Radium.ToggleSwitch = Ember.View.extend
  classNames: ['toggle-switch']
  template: Ember.Handlebars.compile """
    <label for="{{unbound view.checkBoxId}}">
      {{view.label}}
      <input id="{{unbound view.checkBoxId}}" type="checkbox" {{bindAttr checked="view.checked"}}>
      <div class="switch"></div>
    </label>
  """

  init: ->
    @_super.apply this, arguments
    @on 'change', this, @_updateElementValue

  checkBoxId: (->
    "checker-#{@get('elementId')}"
  ).property()

  _updateElementValue: ->
    @set 'checked', @$('input').prop('checked')

Radium.TrackingSwitch = Radium.ToggleSwitch.extend
  classNames: ['tracking-switch', 'green-yellow']
