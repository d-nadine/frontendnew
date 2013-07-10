Radium.EmailsItemView = Radium.View.extend Radium.ContentIdentificationMixin,
  publicToggleSwitch: Radium.PublicSwitch.extend
    checkedBinding: 'isPublic'

    isPublic: ((key, value)  ->
      if arguments.length == 2
        @set 'controller.isPersonal', !value
        @get('controller.store').commit()
      else
        !@get('controller.isPersonal')
    ).property('controller.isPersonal')
