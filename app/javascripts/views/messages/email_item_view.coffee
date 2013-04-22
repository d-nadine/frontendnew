Radium.MessagesEmailItemView = Radium.View.extend Radium.ContentIdentificationMixin,
  trackedToggleSwitch: Radium.TrackingSwitch.extend
    checkedBinding: 'controller.isTracked'
