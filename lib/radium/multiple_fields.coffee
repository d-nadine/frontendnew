require 'lib/radium/multiple_field'
require 'lib/radium/address_multiple_field'

Radium.MultipleFields = Ember.ContainerView.extend
  currentIndex: -1
  inputType: 'text'
  viewType: Radium.MultipleField
  canReset: false
  didInsertElement: ->
    @_super.apply this, arguments
    @get('source').forEach (source) =>
      if source.get('value')
        Ember.run =>
          @addNew()

    @addNew() unless @get('childViews.length')

  willDestroyElement: ->
    @_super.apply this, arguments

    unsaved = @get('source').filter (item) ->
                not item.get('value')

    unsaved.forEach (item) ->
      item.deleteRecord()

    @get('source').removeObjects unsaved

    if !@get('source').findProperty('isPrimary') && @get('source.length')
      @set('source.firstObject.isPrimary', true)

  sourceDidChange: ( ->
    return unless @get('canReset')
    return unless @get('source')

    index = 0

    @get('labels').forEach (label) =>
      existing = @get('source').find (item) ->
        item.get('name') == label

      unless existing
        record = @get('type').createRecord({name: label, value: ''})
        @get('source').insertAt(index, record)

      index++

    @clear()

    @set('currentIndex', -1)

    @get('source').forEach (source) =>
      if source.get('value')
        Ember.run =>
          @addNew()

    unless @get('childViews.length')
      @addNew()
    else
      isPrimary = @get('source').findProperty 'isPrimary'

      unless isPrimary
        @set('source.firstObject.isPrimary', true)

  ).observes('source.[]')

  removeSelection: (view) ->
    view.set('current.value', null)

    currentViewIsPrimary = view.get('current.isPrimary')

    view.set('current.isPrimary', false)

    @get('source').removeObject(view.get('current'))
    @get('source').pushObject(view.get('current'))

    @removeObject view

    newIndex = 0

    @get('childViews').forEach (childView) ->
      childView.set('index', newIndex)
      newIndex += 1

      if currentViewIsPrimary
        childView.set('current.isPrimary', true)
        currentViewIsPrimary = false

    @set('currentIndex', @get('currentIndex') - 1)

  addNew: ->
    @set('currentIndex', @get('currentIndex') + 1)

    currentIndex = @get('currentIndex')

    label = @get('labels')[currentIndex]

    existing = @get('source').findProperty 'name', label

    unless existing
      record = @get('type').createRecord({name: label, value: ''})
      @get('source').insertAt(currentIndex, record)

    @pushObject(@get('viewType').create
      classNameBindings: [':control-group']
      source: @get('source')
      leader: @get('leader')
      type: @get('inputType')
      index: @get('currentIndex')
    )
