Radium.PeopleIndexRoute = Radium.Route.extend
  actions:
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

  beforeModel: (transition) ->
    filter = transition.params['people.index'].filter

    controller = @controllerFor 'people.index'

    controller.send 'updateTotals'
    controller.set 'filter', filter

  model: (params) ->
    controller = @controllerFor 'peopleIndex'

    controller.set('user', params.user) if params.user

    controller.set('tag', params.tag) if params.tag

    controller.set 'filter', params.filter

    filterParams = controller.get('filterParams')

    Radium.InfiniteDataset.create
      type: Radium.Contact
      params: filterParams

  deactivate: ->
    @_super.apply this, arguments

    Ember.run.next =>
      @controller.get('checkedContent').setEach 'isChecked', false
      @controller.get('columns').setEach 'checked', false
      @controller.get('columns').slice(0, 6).setEach 'checked', true