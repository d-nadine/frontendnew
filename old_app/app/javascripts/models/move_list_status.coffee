Radium.MoveListStatus = Radium.Model.extend
  direction: DS.attr('string')
  listStatus: DS.belongsTo('Radium.ListStatus')
