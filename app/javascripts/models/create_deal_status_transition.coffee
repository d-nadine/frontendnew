Radium.CreateDealStatusTransition = Radium.Model.extend
  deal: DS.belongsTo('Radium.Deal')
  listStatus: DS.belongsTo('Radium.ListStatus')

  inactiveReason: DS.attr('string')
