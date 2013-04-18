require 'lib/radium/multiple_field'
require 'lib/radium/address_multiple_field'

Radium.MultipleFields = Ember.ContainerView.extend
  currentIndex: -1
  viewType: Radium.MultipleField
  didInsertElement: ->
    @_super.apply this, arguments
    @set('source.firstObject.isPrimary', true) if @get('source.length')
    @addNew()

  sourceDidChange: ( ->
    return unless @get('source')

    @clear()

    @set('currentIndex', -1)

    @get('source').forEach (source) =>
      if source.get('value')
        Ember.run =>
          @addNew()

    unless @get('childViews.length')
      @addNew()
    else
      debugger
      isPrimary = @get('source').find (item) ->
        item.get('isPrimary')

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
    @pushObject(@get('viewType').create
      classNameBindings: [':control-group']
      source: @get('source')
      leader: @get('leader')
      type: @get('type')
      index: @get('currentIndex')
    )
