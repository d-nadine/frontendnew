Radium.ThirdpartyIntegration = Radium.Model.extend
  name: DS.attr('string')
  config: DS.attr('object')
  lists: DS.hasMany('Radium.List')
  newLists: DS.attr('array', defaultValue: [])
