Radium.AddList = Radium.Model.extend
  contact: DS.belongsTo('Radium.Contact')
  list: DS.belongsTo('Radium.List')

Radium.RemoveList = Radium.AddList.extend()
