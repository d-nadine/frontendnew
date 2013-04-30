Radium.EmailsItemView = Radium.View.extend Radium.ContentIdentificationMixin,
  trackedToggleSwitch: Radium.TrackingSwitch.extend
    checkedBinding: 'controller.isTracked'
