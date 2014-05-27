require 'controllers/pipeline/base_controller'
require 'controllers/pipeline/filter_mixin'

Radium.PipelineDealsController = Radium.PipelineBaseController.extend Radium.FilterMixin,
  actions:
    toggleChecked: ->
      allChecked = @get('checkedContent.length') == @get('length')

      @get('content').forEach (item) ->
        item.set 'isChecked', !allChecked

    sortDeals: (column, ascending) ->
      Ember.run =>
        @set 'sort', column
        @set 'sortAscending', ascending
        @notifyPropertyChange 'sort'

  init: ->
    @_super.apply this, arguments
    parentController = @get('parentController.parentController')
    return unless parentController instanceof Radium.PipelineIndexController
    Ember.bind(this, 'searchText', 'parentController.parentController.searchText')
    Ember.bind(this, 'selectedFilter', 'parentController.parentController.selectedFilter')

  resultsDidChange: Ember.observer('arrangedContent.[]', 'selectedFilter', 'searchText', ->
    unless parentController = @get('parentController')
      return

    return unless parentController instanceof Radium.WorkflowGroupItemController

    return if parentController.get("isDestroying")

    parentController.set('arrangedDealsLength', @get('length'))

    if @get('length')
      parentController.set('hide', false)
    else
      parentController.set('hide', true)
  ).on('init')

  sortFunc: (a, b) ->
    sort = @get('sort')
    sortAscending = @get('sortAscending')

    if sortAscending
      left = a
      right = b
    else
      left = b
      right = a

    if sort == 'nextTask'
      sortA = left.get('nextTask')
      sortB = right.get('nextTask')

      if !sortA && !sortB
        return 0
      else if !sortA && sortB
        return -1
      else if sortA && !sortB
        return 1

      return Ember.DateTime.compare sortA.get('time'), sortB.get('time')

    if sort == 'updatedAt'
      return Ember.DateTime.compare left.get(sort), right.get(sort)

    Ember.compare left.get(sort), right.get(sort)

  arrangedContent: Ember.computed 'content.[]', 'selectedFilter', 'searchText', 'sort', 'sortAscending', ->
    content = @get('content')
    sortFunc = @sortFunc.bind this

    return Ember.A() unless content.get('length')

    searchText = @get('searchText')

    return content.toArray().sort(sortFunc) unless searchText?.length

    selectedFilter = @get('selectedFilter')

    content.setEach 'isChecked', false

    content = content.filter (item) ->
                  if selectedFilter == 'name'
                    ~item.get('name').toLowerCase().indexOf(searchText.toLowerCase())
                  else if selectedFilter == 'company'
                    item.get('contact.company') && ~item.get('displayName').toLowerCase().indexOf(searchText.toLowerCase())
                  else
                    ~item.get(selectedFilter).get('displayName').toLowerCase().indexOf(searchText.toLowerCase())

    content.toArray().sort(sortFunc)

  dealValues: Ember.computed.mapBy 'arrangedContent', 'value'
  total: Ember.computed.sum 'dealValues'
