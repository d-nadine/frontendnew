Radium.PeopleIndexRoute = Radium.Route.extend
  actions:
    willTransition: (transition) ->
      unless transition.targetName == 'people.index'
        @controller.set 'company', null

      unless transition.targetName == "emails.new"
        @controller.set 'searchText', ''
        @controller.get('checkedContent').setEach 'isChecked', false
        @controller.set('allChecked', false)

      true

    confirmDeletion: ->
      controller = @controllerFor 'peopleIndex'

      unless controller.get('allChecked') || controller.get('checkedContent.length')
        return @send 'flashError', "You have not selected any items."

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
    customquery:
      refreshModel: true

  beforeModel: (transition) ->
    filter = transition.params['people.index'].filter

    controller = @controllerFor 'peopleIndex'

    controller.send 'updateTotals'
    controller.set 'filter', filter
    controller.set 'allChecked', false
    controller.get('content').setEach 'isChecked', false
    controller.set 'searchText', ''

    new Ember.RSVP.Promise (resolve, reject) ->
      Radium.CustomField.find({}).then((results) ->
        controller.set 'customFields', results
        resolve()
      ).catch (error) ->
        Ember.Logger.error(error)
        reject error

  model: (params) ->
    controller = @controllerFor 'peopleIndex'

    controller.set('user', params.user) if params.user

    controller.set('tag', params.tag) if params.tag

    controller.set('customquery', params.customquery) if params.customquery

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

  afterModel: (model) ->
    controller = @controllerFor 'peopleIndex'
    currentUser = controller.get('currentUser')

    controller.set 'potentialQueries', Ember.A()
    controller.set 'actualQueries', Ember.A()

    unless controller.get('isQuery')
      return controller.resetCustomQuery()

    customQuery = currentUser.get('customQueries').find (q) -> q.get('uid') == controller.get('customquery')

    potentialQueries = customQuery.get('customQueryParts').map (part) ->
                         field: part.get('field')
                         operatorType: part.get('operatorType')
                         operator: part.get('operator')
                         displayName: controller.get('combinedQueryFields').find((q) -> q.field == part.get('field')).displayName
                         value: part.get('value')
                         customfieldid: part.get('customfieldid')

    controller.set 'potentialQueries', potentialQueries.slice()
    controller.set 'actualQueries', potentialQueries.slice()

  deactivate: ->
    @controller.set 'newTags', Ember.A()
    @controller.set 'potentialQueries', Ember.A()
    @controller.set 'actualQueries', Ember.A()
    @set 'customquery', null
