require 'controllers/multiple/multiple_controller'

Radium.MultipleAddressController = Radium.MultipleController.extend
  needs: ['countries']
  leader: 'Address'
