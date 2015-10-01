Radium.AddListAction = Radium.Model.extend
  listStatus: DS.belongsTo('Radium.ListStatus')
  list: DS.belongsTo('Radium.List')
  action: DS.attr('string')