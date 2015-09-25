Radium.List = Radium.Model.extend
  name: DS.attr('string')
  itemName: DS.attr('string')
  type: DS.attr('string')

  listStatuses: DS.hasMany('Radium.ListStatus')

  contactList: Ember.computed.equal 'type', 'contacts'
  companiesList: Ember.computed.equal 'type', 'companies'

  clearRelationships: ->
    @get('listStatuses').compact().forEach (status) ->
      status.unloadRecord()