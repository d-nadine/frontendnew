Radium.PeopleIndexRoute = Radium.Route.extend
  actions:
    willTransition: (transition) ->
      unless transition.targetName == "emails.new"
        @controller.set 'searchText', ''
        @controller.get('checkedContent').setEach 'isChecked', false
        @controller.set('allChecked', false)

      true

    confirmDeletion: ->
      controller = @controllerFor 'peopleIndex'

      unless controller.get('allChecked') || controller.get('checkedContent.length')
        return @send 'flashError', "You have not selected any contacts."

      @render 'people/deletion_confirmation',
        into: 'application',
        outlet: 'modal',

    close: ->
      @render 'nothing',
        into: 'application',
        outlet: 'modal'

  queryParams:
    user:
      refreshModel: true
    tag:
      refreshModel: true
    company:
      refreshModel: true
    contactimportjob:
      refreshModel: true

  beforeModel: (transition) ->
    filter = transition.params['people.index'].filter

    controller = @controllerFor 'people.index'

    controller.send 'updateTotals'
    controller.set 'filter', filter

  model: (params) ->
    controller = @controllerFor 'peopleIndex'

    controller.set('user', params.user) if params.user

    controller.set('tag', params.tag) if params.tag

    controller.set('company', params.company)

    controller.set('contactimportjob', params.contactimportjob)

    controller.set 'filter', params.filter

    filterParams = controller.get('filterParams')

    Radium.InfiniteDataset.create
      type: Radium.Contact
      params: filterParams

  activate: ->
    controller = @controllerFor('peopleIndex')

    unless savedColumns = JSON.parse(localStorage.getItem(controller.SAVED_COLUMNS))
      savedColumns = controller.initialColumns

      localStorage.setItem controller.SAVED_COLUMNS, JSON.stringify(savedColumns)

    controller.get('columns').filter((c) -> savedColumns.contains(c.id)).setEach 'checked', true

  deactivate: ->
    @controller.set 'newTags', Ember.A()