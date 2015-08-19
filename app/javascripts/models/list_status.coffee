Radium.ListStatus = Radium.Model.extend
  name: DS.attr('string')
  position: DS.attr('number')
  statusType: DS.attr('string')
  list: DS.belongsTo('Radium.List')
