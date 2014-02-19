Radium.WorkflowGroupItemController = Radium.ArrayController.extend
  needs: ['pipeline']
  arrangedDealsLength: 0

  hide: false

  workflowTotal: Ember.computed.alias('controllers.pipeline.content.workflowTotal')
  selectedGroup: Ember.computed.alias('controllers.pipeline.selectedGroup')

  deals: Ember.computed.alias('content')

  expand: ->
    @toggleProperty 'isExpanded'
    @set 'selectedGroup', @get('content.title') if @get('isExpanded')

  selectedGroupDidChange: (->
    selectedGroup = @get 'selectedGroup'
    return unless selectedGroup

    @set('isExpanded', @get('content.title') == selectedGroup)
  ).observes('selectedGroup', 'deals.[]')

  percentage: (->
    total = @get 'workflowTotal'
    length = @get 'length'

    return 0 unless total && length

    Math.floor((length / total) * 100)
  ).property('workflowTotal', 'length')

  total: (->
    return 0 if @get('length') == 0

    @reduce(((value, item) ->
      value + item.get('value')
    ), 0)
  ).property('length')

  isWorkflow: ( ->
    title = @get('content.title')
    not ['closed', 'lost', 'unpublished'].contains(title)
  ).property('content.title')

  isClosed: ( ->
    @get('content.title').toLowerCase() == 'closed'
  ).property('content.title')

  isLost: ( ->
    @get('content.title').toLowerCase() == 'lost'
  ).property('content.title')

  title: ( ->
    "#{@get('content.title')} - (#{@get('length')})"
  ).property('status', 'deals.length')

  deleteObject: (record) ->
    record.deleteRecord()

    @get('store').commit()

    @send "flashSuccess", "deleted!"
