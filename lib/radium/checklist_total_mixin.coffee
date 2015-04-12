Radium.ChecklistTotalMixin = Ember.Mixin.create
  total: Ember.computed 'checklist.@each.isFinished', ->
    @get('checklist').reduce((preVal, item) ->
      weight = if item.get('isFinished') then item.get('weight') else 0

      preVal + weight
    , 0, 'weight')

  percentage: Ember.computed 'total', ->
    total = @get('total')

    if total > 100 then 100 else total
