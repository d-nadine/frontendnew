Radium.PipelineNegotiatingGroupController = Radium.ArrayController.extend
  needs: ['pipeline']

  negotiatingTotal: Ember.computed.alias('controllers.pipeline.content.negotiatingTotal')
  selectedGroup: Ember.computed.alias('controllers.pipeline.selectedGroup')

  deals: Ember.computed.alias('content')

  expand: ->
    @toggleProperty 'isExpanded'

  selectedGroupDidChange: (->
    selectedGroup = @get 'selectedGroup'
    return unless selectedGroup

    @set('isExpanded', @get('content') == selectedGroup)
  ).observes('selectedGroup')

  percentage: (->
    total = @get 'negotiatingTotal'
    length = @get 'length'

    return 0 unless total || total == 0 || length == 0

    Math.floor((length / total) * 100)
  ).property('negotiatingTotal', 'length')

  total: (->
    return 0 if @get('length') == 0

    @reduce(((value, item) ->
      value + item.get('value')
    ), 0)
  ).property('length')

  title: ( ->
    "#{@get('content.title')} - (#{@get('length')})"
  ).property('status', 'deals.length')

  deleteObject: (record) ->
    record.deleteRecord()

    @get('store').commit()

    Radium.Utils.notify "deleted!"
