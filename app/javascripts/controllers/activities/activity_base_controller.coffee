Radium.ActivityBaseController = Radium.ObjectController.extend
  referenceDidChange: ( ->
    unless reference = @get('reference')
      return

    return if reference.get('isLoaded')

    if reference.constructor.all().find((item) -> item.get('id') == reference.get('id'))
      return

    Ember.run.later =>
      reference.reload()
    , 100
  ).observes('reference').on('init')
