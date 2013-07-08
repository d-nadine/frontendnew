Radium.EmailsItemView = Radium.View.extend Radium.ContentIdentificationMixin,
  publicToggleSwitch: Radium.PublicSwitch.extend
    checkedBinding: 'controller.isPublic'
