require 'lib/radium/company_picker'

Radium.ContactCompanyPicker = Radium.AutocompleteCombobox.extend
  classNameBindings: [':company-name']
  valueBinding: 'controller.company'
  placeholder: 'Company'
  companyNameBinding: 'controller.companyName'
  autocompleteResultType: Radium.AutocompleteCompany

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
