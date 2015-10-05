Radium.List = Radium.Model.extend
  name: DS.attr('string')
  itemName: DS.attr('string')
  type: DS.attr('string')

  listStatuses: DS.hasMany('Radium.ListStatus', inverse: 'list')

  contactList: Ember.computed.equal 'type', 'contacts'
  companiesList: Ember.computed.equal 'type', 'companies'

  actionListStatus: DS.belongsTo('Radium.ListStatus', inverse: null)
  listAction: DS.attr('string')
  actionList: DS.belongsTo('Radium.List', inverse: null)
  initialStatus: DS.belongsTo('Radium.ListStatus', inverse: null)

  clearRelationships: ->
    @get('listStatuses').compact().forEach (status) ->
      status.unloadRecord()
