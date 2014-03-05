require 'lib/radium/company_picker'

Radium.ContactCompanyPicker = Radium.CompanyPicker.extend
  classNameBindings: [':company-name']
  valueBinding: 'controller.company'
  placeholder: 'Choose or add a Company'
  companyNameBinding: 'controller.companyName'

  didInsertElement: ->
    @_super.apply this, arguments
    @set 'companyName', @get('value.name') if @get('value.name')

  queryToValueTransform: ((key, value) ->
    if arguments.length == 2
      if @matchesSelection(value)
        @set 'companyName', value
        @select()
      else
        @set 'companyName', value
    else if !value && @get('value')
      @get 'value.name'
    else
      value
  ).property('value')

  setValue: (object) ->
    @set 'value', object
    @set 'companyName', @get('value').get('name')
