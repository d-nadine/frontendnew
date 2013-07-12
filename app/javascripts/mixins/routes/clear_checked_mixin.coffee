Radium.ClearCheckedMixin = Ember.Mixin.create
  clearChecked: ->
    controller = @controllerFor('pipelineWorkflowDeals')
    return unless controller.get('hasCheckedContent')
    controller.get('content').forEach (item) =>
      item.set('isChecked', false)


