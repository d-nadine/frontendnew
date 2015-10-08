require 'components/autocomplete-textbox_component'
require 'mixins/company_autocomplete_mixin'

Radium.CompanyAutocompleteComponent = Radium.AutocompleteTextboxComponent.extend Radium.CompanyAutocompleteMixin,
  actions:
    setBindingValue: (object, index) ->
      if id = object.get('id')
        @set('company.id', id)
        @set('company.name', object.get('name'))
      else
        @set('company.logo', object.get('logo'))
        @set('company.name', object.get('name'))
        @set('company.website', object.get('website'))

      @set 'value', object.get('name')

      @setValueText()

      @getTypeahead().hide()

      false
