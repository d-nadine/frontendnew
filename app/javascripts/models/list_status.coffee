Radium.ListStatus = Radium.Model.extend
  name: DS.attr('string')
  position: DS.attr('number')

  list: DS.belongsTo('Radium.List')
