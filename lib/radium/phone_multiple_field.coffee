require 'lib/radium/multiple_field'
require 'lib/radium/phone_input'

Radium.PhoneMultipleField = Radium.MultipleField.extend
  classNameBindings: ['isInvalid']
  valueBinding: 'current.value'
  template: Ember.Handlebars.compile """
    {{view view.textBox typeBinding="view.type" classNames="field input-xlarge" valueBinding="view.current.value" placeholderBinding="view.leader" readonlyBinding="view.readonly"}}
  """

  textBox: Radium.PhoneInput.extend()
