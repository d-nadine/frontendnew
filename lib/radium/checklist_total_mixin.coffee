Radium.ChecklistTotalMixin = Ember.Mixin.create
  total: ( ->
    total = 0

    @get('checklistItems').forEach (item) ->
      total += item.get('weight') if item.get('isFinished')

    total
  ).property('checklistItems.@each.isFinished')

  percentage: ( ->
    total = @get('total')

    if total > 100 then 100 else total
  ).property('total')


