Radium.QueryItemComponent = Ember.Component.extend
  actions:
    showCustomQueryContacts: ->
      @get('parent').send 'showCustomQueryContacts', @get('customQuery')

      false

    deleteCustomQuery: ->
      @get('parent').send 'deleteCustomQuery', @get('customQuery')

      false

  classNameBindings: ['isCurrent:active']
  isQuery: Ember.computed.oneWay 'parent.isQuery'

  isCurrent: Ember.computed 'parent.customquery', 'isQuery', 'customQuery', ->
    return unless @get('isQuery') && @get('customQuery')

    @get('customQuery.uid') == @get('parent.customquery')
