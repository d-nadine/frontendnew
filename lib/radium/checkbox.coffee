Radium.Checkbox = Radium.View.extend
  classNameBindings: ['checked:checked:unchecked', ':checker']


  template: Ember.Handlebars.compile """
    <input type="checkbox" id="{{unbound view.checkBoxId}}" {{bind-attr disabled=view.disabled}}/>
    <label for="{{unbound view.checkBoxId}}" class="ss-standard ss-check inline-form-icon"></label>
  """
