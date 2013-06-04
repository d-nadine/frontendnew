require 'lib/radium/company_picker'

Radium.ContactCompanyPicker = Radium.Combobox.extend
  classNameBindings: [':company-name']
  sourceBinding: 'controller.controllers.companies'
  valueBinding: 'controller.company'
  placeholder: 'Company'
  companyNameBinding: 'controller.companyName'

  didInsertElement: ->
    @_super.apply this, arguments
    @set 'companyName', @get('value.name') if @get('value.name')

  queryToValueTransform: ((key, value) ->
    if arguments.length == 2
      lookUp = @lookupQuery(value)
      @set 'companyName', if lookUp then lookUp.get('name') else value
      @set 'value', @lookupQuery(lookUp)
    else if !value && @get('value')
      @get 'value.name'
    else
      value
  ).property('value')

  setValue: (object) ->
    @set 'value', object
    @set 'companyName', @get('value').get('name')
