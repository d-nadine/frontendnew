Radium.ChecklistTotalMixin = Ember.Mixin.create
  total: ( ->
    @get('forecast').reduce((preVal, item) ->
      weight = if item.get('isFinished') then item.get('weight') else 0

      preVal + weight
    , 0, 'weight')
  ).property('forecast.@each.isFinished')

  percentage: ( ->
    total = @get('total')

    if total > 100 then 100 else total
  ).property('total')


