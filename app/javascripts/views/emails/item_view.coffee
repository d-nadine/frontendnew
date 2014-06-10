Radium.EmailsItemView = Radium.View.extend Radium.ContentIdentificationMixin,
  classNames: ['email-thread-item']

  content: Ember.computed 'controller.content', ->
    unless content = @get('controller.content')
      return

    if content instanceof Radium.ObjectController
      content.get('content')
    else
      content

  publicToggleSwitch: Radium.PublicSwitch.extend
    checkedBinding: 'isPublic'

    isPublic: Ember.computed 'controller.isPublic', (key, value)  ->
      if arguments.length == 2
        @set 'controller.isPersonal', !value
      else
        !@get('controller.isPersonal')
