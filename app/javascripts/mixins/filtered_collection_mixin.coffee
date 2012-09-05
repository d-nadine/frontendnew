
Radium.FilteredCollectionMixin = Em.Mixin.create
  # NOTE: it may be slow, investigate if there are problems with filtering
  content: (->
    Radium.FilteredArray.create
      context: this
      contentBinding: 'context.collection'
      filterProperties: ['type']
      filterValueBinding: 'context.controller.typeFilter'
      filterCondition: (item) ->
        if filterValue = @get('filterValue')
          item.get('strType') == filterValue
        else
          true
  ).property()

  filterObserver: (->
    @get('content').notifyPropertyChange('filterProperties')
  ).observes('controller.typeFilter', 'controller')
