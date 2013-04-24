Radium.ChecklistTotalMixin = Ember.Mixin.create
  total: ( ->
    @get('checklistItems').reduce((preVal, item) ->
      weight = if item.get('isFinished') then item.get('weight') else 0

      preVal + weight
    , 0, 'weight')
  ).property('checklistItems.@each.isFinished')

  percentage: ( ->
    total = @get('total')

    if total > 100 then 100 else total
  ).property('total')


