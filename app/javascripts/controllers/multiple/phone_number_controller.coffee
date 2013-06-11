require 'controllers/multiple/multiple_controller'

Radium.MultiplePhoneNumberController = Radium.MultipleController.extend
  labels: ['Mobile', 'Work','Home']
  leader: 'Phone'
