Radium.ListStatus = Radium.Model.extend
  name: DS.attr('string')
  position: DS.attr('number')
  statusType: DS.attr('string')
  list: DS.belongsTo('Radium.List', inverse: )
  listAction: DS.attr('string')
  actionList: DS.belongsTo('Radium.List', inverse: null)

  isActive: Ember.computed 'statusType', ->
    @get('statusType') == "active"