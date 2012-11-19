# TODO: this is almost identical with FilteredCollectionMixin,
#       unify it when it's sure that contacts are well done
Radium.FilteredContactsMixin = Em.Mixin.create
  content: (->
    Radium.FilteredArray.create
      context: this
      contentBinding: 'context.collection'
      filterProperties: ['status']
      filterValueBinding: 'context.typeFilter'
      filterValuesBinding: 'context.typeFilters'
      filterCondition: (item) ->
        if filterValue = @get('filterValue')
          item.get('status') == filterValue
        else if filterValues = @get('filterValues')
          filterValues.contains item.get('status')
        else
          true
  ).property()

 filterObserver: (->
    @get('content').notifyPropertyChange('filterProperties')
  ).observes('typeFilter')

