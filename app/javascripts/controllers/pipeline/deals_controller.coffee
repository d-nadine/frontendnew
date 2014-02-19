require 'controllers/pipeline/base_controller'

Radium.PipelineDealsController = Radium.PipelineBaseController.extend
  actions:
    changeFilter: (filter) ->
      @set 'selectedFilter', filter

  toggleChecked: ->
    allChecked = @get('checkedContent.length') == @get('length')

    @get('content').forEach (item) ->
      item.set 'isChecked', !allChecked

  selectedFilter: 'name'
  searchText: null

  init: ->
    @_super.apply this, arguments
    parentController = @get('parentController.parentController')
    return unless parentController instanceof Radium.PipelineIndexController
    Ember.bind(this, 'searchText', 'parentController.parentController.searchText')

  resultsDidChange: ( ->
    unless parentController = @get('parentController')
      return

    return unless parentController instanceof Radium.WorkflowGroupItemController

    return if parentController.get("isDestroying")

    parentController.set('arrangedDealsLength', @get('length'))

    if @get('length')
      parentController.set('hide', false)
    else
      parentController.set('hide', true)
  ).observes('arrangedContent.[]', 'selectedFilter', 'searchText').on('init')

  arrangedContent: ( ->
    content = @get('content')

    return Ember.A() unless content.get('length')

    searchText = @get('searchText')

    return content unless searchText?.length

    selectedFilter = @get('selectedFilter')

    content.setEach 'isChecked', false

    content = content.filter (item) ->
                  if selectedFilter == 'name'
                    ~item.get('name').toLowerCase().indexOf(searchText.toLowerCase())
                  else if selectedFilter == 'company'
                    item.get('contact.company') && ~item.get('name').toLowerCase().indexOf(searchText.toLowerCase())
                  else
                    ~item.get(selectedFilter).get('name').toLowerCase().indexOf(searchText.toLowerCase())

    content
  ).property('content.[]', 'selectedFilter', 'searchText')

  selectedFilterText: ( ->
    @get('filters').findProperty('name', @get('selectedFilter')).text
  ).property('selectedFilter')

  filters: [
    {name: 'name', text: 'Filter By Name'}
    {name: 'contact', text: 'Filter By Contact'}
    {name: 'company', text: 'Filter By Company'}
    {name: 'user', text: 'Filter By Assigned'}
  ]

  dealValues: Ember.computed.mapBy 'visibleContent', 'value'
  total: Ember.computed.sum 'dealValues'
