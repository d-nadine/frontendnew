require 'lib/radium/masked_multiple_field'

Radium.MaskedMultipleFields = Radium.MultipleFields.extend
  viewType: Radium.MaskedMultipleField
  mask: '(999) 999-9999'
