require 'components/inline-autocomplete_component'
require 'mixins/company_autocomplete_mixin'

Radium.InlineCompanyautocompleteComponent = Ember.Component.extend Radium.CompanyAutocompleteMixin,
  classNameBindings: ['isEditing']
  focusIn: (e) ->
    @_super.apply this, arguments

    @set 'isEditing', true

  focusOut: (e) ->
    @_super.apply this, arguments

    @set 'isEditing', false

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    model = @get('model')
    companyForm =
      companyName: model?.get('name')
      company: model

    @set 'companyForm', companyForm
    @set 'company', companyForm.company

    @EventBus.subscribe 'rerender-company', this, 'rerenderAll'

  rerenderAll: ->
    return if @isDestoyed || @isDestoying
    Ember.run.scheduleOnce('render', this, 'rerender')
