Radium.EmailsItemView = Radium.View.extend Radium.ContentIdentificationMixin,
  classNames: ['email-thread-item', 'row-fluid']

  content: Ember.computed 'controller.content', ->
    unless content = @get('controller.content')
      return

    if content instanceof Radium.ObjectController
      content.get('content')
    else
      content