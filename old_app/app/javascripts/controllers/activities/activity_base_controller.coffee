Radium.ActivityBaseController = Radium.ObjectController.extend
  needs: ['application', 'user']

  avatarReference: Ember.computed 'user', 'reference', 'reference.isLoaded', ->
    reference = @get('reference')

    return @get('user') unless reference && reference.constructor is Radium.Contact

    reference

  referenceDidChange: ( ->
    unless reference = @get('reference')
      return

    return if reference.get('isLoaded')

    if reference.constructor.all().find((item) -> item.get('id') == reference.get('id'))
      return

    rand = Math.round(Math.random() * (1000 - 500)) + 500

    model = @get('model')

    store = @get('store')

    Ember.run.later ->
      if reference.get('currentState.stateName') == 'root.error'
        model.deleteRecord()

        store.commit()
      else
        reference.reload()
    , rand
  ).observes('reference').on('init')
