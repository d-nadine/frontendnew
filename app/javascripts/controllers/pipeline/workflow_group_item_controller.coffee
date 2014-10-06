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

  selectedGroupDidChange: Ember.observer 'selectedGroup', 'deals.[]', ->
    selectedGroup = @get 'selectedGroup'
    return unless selectedGroup

    @set('isExpanded', @get('content.title') == selectedGroup)

  percentage: Ember.computed 'workflowTotal', 'length', ->
    total = @get 'workflowTotal'
    length = @get 'length'

    return 0 unless total && length

    Math.floor((length / total) * 100)

  total: Ember.computed 'length', ->
    return 0 if @get('length') == 0

    @reduce(((value, item) ->
      value + item.get('value')
    ), 0)

  dasherized: Ember.computed 'model.title', ->
    @get('model.title').dasherize()

  isWorkflow: Ember.computed 'dasherized', ->
    title = @get('dasherized')
    not ['closed', 'lost', 'unpublished'].contains(title)

  isClosed: Ember.computed 'dasherized', ->
    @get('dasherized') == 'closed'

  isLost: Ember.computed 'dasherized', ->
    @get('dasherized') == 'lost'

  title: Ember.computed 'status', 'deals.[]', ->
    "#{@get('content.title')} - (#{@get('length')})"

  deleteObject: (record) ->
    record.deleteRecord()

    @get('store').commit()

    @send "flashSuccess", "deleted!"
