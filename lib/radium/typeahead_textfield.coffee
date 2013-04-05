require 'lib/radium/typeahead'

Radium.TypeaheadTextField = Ember.View.extend
  classNameBindings: ['isInvalid','open',':controls',':control-box',':name']
  template: Ember.Handlebars.compile """
    {{view view.textField}}
  """

  queryBinding: 'queryToValueTransform'

  isSubmitted: Ember.computed.alias('controller.isSubmitted')

  isInvalid: (->
    Ember.isEmpty(@get('value')) && @get('isSubmitted')
  ).property('value', 'isSubmitted')

  lookupQuery: (query) ->
    @get('source').find (item) -> item.get('name') == query

  queryToValueTransform: ((key, value) ->
    if arguments.length == 2
      lookUp =  @lookupQuery(value)
      if lookUp
        @set 'value', lookUp.get('name')
        @$('input[type=text]').blur()
        @clearValue()
      else
        if @get('isExistingContact')
          @clearValue()
        @set 'value', value
    else if !value && @get('value')
      @get 'value'
    else
      value
  ).property('value')

  clearValue: ->
    @set 'value', null

  setValue: (object) ->
    @set 'value', object

  textField: Radium.Typeahead.extend
    attributeBindings: ['autocomplete']
    autocomplete: 'off'
    valueBinding: 'parentView.query'
    disabledBinding: 'parentView.disabled'
    placeholderBinding: 'parentView.placeholder'
    sourceBinding: 'parentView.source'
