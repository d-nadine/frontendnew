Radium.FilteredCollectionMixin = Em.Mixin.create
  # NOTE: it may be slow, investigate if there are problems with filtering
  content: (->
    Radium.FilteredArray.create
      context: this
      contentBinding: 'context.collection'
      filterProperties: ['strType']
      filterValueBinding: 'context.controller.typeFilter'
      filterValuesBinding: 'context.controller.typeFilters'
      filterCondition: (item) ->
        if filterValue = @get('filterValue')
          item.get('strType') == filterValue
        else if filterValues = @get('filterValues')
          filterValues.contains item.get('strType')
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
