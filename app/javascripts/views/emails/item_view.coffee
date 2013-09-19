Radium.EmailsItemView = Radium.View.extend Radium.ContentIdentificationMixin,
  classNames: ['email-thread-item']

  publicToggleSwitch: Radium.PublicSwitch.extend
    checkedBinding: 'isPublic'

    isPublic: ((key, value)  ->
      if arguments.length == 2
        @set 'controller.isPersonal', !value
      else
        !@get('controller.isPersonal')
    ).property('controller.isPersonal')
