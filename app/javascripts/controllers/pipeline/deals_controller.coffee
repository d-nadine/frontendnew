require 'controllers/pipeline/base_controller'

Radium.PipelineDealsController = Radium.PipelineBaseController.extend
  sort: 'name'
  sortAscending: true
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

  bindSearchText: (->
    parentController = @get('parentController.parentController')
    return unless parentController instanceof Radium.PipelineIndexController
    Ember.bind(this, 'searchText', 'parentController.parentController.searchText')
  ).on("init")

  resultsDidChange: Ember.observer('arrangedContent.[]', 'searchText', ->
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

    if sort == "expectedCloseDate" or sort == 'updatedAt'
      sortA = left.get(sort)
      sortB = right.get(sort)
      if sortA && sortB
        return Ember.DateTime.compare left.get(sort), right.get(sort)
      else if !sortA && !sortB
        return 0
      else if !sortA && sortB
        return -1
      else if sortA && !sortB
        return 1

    Ember.compare left.get(sort), right.get(sort)

  arrangedContent: Ember.computed 'content.[]', 'searchText', 'sort', 'sortAscending', ->
    content = @get('content')
    sortFunc = @sortFunc.bind this

    return Ember.A() unless content.get('length')

    searchText = @get('searchText')

    return content.toArray().sort(sortFunc) unless searchText?.length

    content.setEach 'isChecked', false

    content = content.filter (item) ->

      regex = new RegExp(searchText, "i")
      nameTest = regex.test(item.get('name'))
      contactTest = regex.test(item.get('contact.displayName'))
      assignedTest = regex.test(item.get('user.displayName'))
      companyTest = regex.test(item.get('company.displayName'))

      # Filter on all attrs
      nameTest or assignedTest or contactTest or companyTest

    content.toArray().sort(sortFunc)

  dealValues: Ember.computed.mapBy 'arrangedContent', 'value'
  total: Ember.computed.sum 'dealValues'
