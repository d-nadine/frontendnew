require 'lib/radium/multiple_field'

Radium.LeadsNewView = Ember.View.extend
  contacts: Ember.computed.alias 'controller.contacts'
  contactExists: Ember.computed.bool 'value'
  valueBinding: 'controller.selectedContact'
  isNewLead: false

  phoneNumbers: Radium.MultipleField.extend
    classNames: ['control-group']
    # FIXME: use real data
    source: [
      { name: "Mobile", value: "+1348793247" }
      { name: "Work", value: "+934728783" }
      { name: "Home", value: "+35832478388" }
    ]

  existingContactChecker: Radium.Typeahead.extend
    classNames: 'field input-xlarge'
    valueBinding: 'parentView.query'
    disabledBinding: 'parentView.disabled'
    placeholderBinding: 'parentView.placeholder'
    sourceBinding: 'controller.contacts'
    timeoutId: null
    keyDown: (evt) ->
      timeoutId = @get('timeoutId')
      if timeoutId
        clearTimeout timeoutId

      timeoutId = setTimeout(( =>
        parentView = @get('parentView')
        value = @get('value')

        if parentView.get('value') || value?.length < 3
          parentView.set('isNewLead', false)
          return

        parentView.set('isNewLead', true)
      ), 800)

  setValue: (object) ->
    @set 'value', object

  queryBinding: 'queryToValueTransform'

  lookupQuery: (query) ->
    @get('contacts').find (item) -> item.get('name') == query

  queryToValueTransform: ((key, value) ->
    if arguments.length == 2
      @set 'value', @lookupQuery(value)
    else if !value && @get('value')
      @get 'value.name'
    else
      value
  ).property('value')
