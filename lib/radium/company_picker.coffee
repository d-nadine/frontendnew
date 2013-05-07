Radium.CompanyPicker = Radium.Combobox.extend
  classNameBindings: [':company-name']
  sourceBinding: 'controller.controllers.companies'
  valueBinding: 'controller.company'
  placeholder: 'Company'
  companyNameBinding: 'controller.companyName'

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
