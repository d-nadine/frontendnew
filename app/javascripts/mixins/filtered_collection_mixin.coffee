require 'radium/filtered_array'

Radium.FilteredCollectionMixin = Em.Mixin.create
  # NOTE: it may be slow, investigate if there are problems with filtering
  content: (->
    Radium.FilteredArray.create
      context: this
      contentBinding: 'context.collection'
      filterProperties: ['type']
      filterValueBinding: 'context.controller.typeFilter'
      filterValuesBinding: 'context.controller.typeFilters'
      filterCondition: (item) ->
        type = if item.get('type').isClass then Radium.Core.typeToString(item.get('type')) else item.get('type')
        if filterValue = @get('filterValue')
          type == filterValue
        else if filterValues = @get('filterValues')
          filterValues.contains type
        else
          true
  ).property()

  didInsertElement: ->
    @_super.apply(this, arguments)

    # And again, observer on notifier does not trigger when
    # insertng the view
    # TODO: investigate why that happens
    @notifyCollectionChanged()

  notifier: (->
    @notifyCollectionChanged()
  ).observes('content.arrangedContent.length')

  notifyCollectionChanged: ->
    if parentView = @get('parentView')
      length = @get('content.arrangedContent.length')
      if length > 0
        @set 'parentView.justRendered', false

      if parentView.notifyCollectionChanged
        parentView.notifyCollectionChanged @toString(), length

  filterObserver: (->
    @get('content').notifyPropertyChange('filterProperties')
  ).observes('controller.typeFilter', 'controller')
