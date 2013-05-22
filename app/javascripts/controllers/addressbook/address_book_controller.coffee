require 'lib/radium/show_more_mixin'
require 'mixins/controllers/bulk_action_controller_mixin'

Radium.AddressbookController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  Radium.CheckableMixin,
  Radium.BulkActionControllerMixin,

  isEditable: true

  init: ->
    @_super.apply this, arguments
    @get('checkedContent').addArrayObserver(this)

  arrayWillChange:  (start, removeCount, addCount) ->
    @set 'activeForm', null

  arrayDidChange: (start, removeCount, addCount) ->
    null

  destroy: ->
    @_super.apply this, arguments
    @get('checkedContent').removeArrayObserver(this)

  filters: [
    {name: 'people', text: 'People'}
    {name: 'assigned', text: 'Assigned To'}
    {name: 'lead', text: 'Lead'}
    {name: 'existing', text: 'Existing Customers'}
    {name: 'exclude', text: 'Excluded from Pipeline'}
    {name: 'companies', text: 'Companies'}
    {name: 'tags', text: 'Tags'}
    {name: 'all', text: 'All'}
  ]

  assignableContent: ( ->
    checkedContent = @get('checkedContent')

    return unless checkedContent.get('length')

    checkedContent.some (item) ->
      item instanceof Radium.Contact || item instanceof Radium.Company
  ).property('checkedContent.[]')

  showAddTags: Ember.computed.equal('activeForm', 'addTags')

  addTagsForm: Radium.computed.newForm('addTags')

  addTagsFormDefaults: ( ->
    tags: Ember.A()
    selectedContent: @get('checkedContent')
  ).property('checkedContent.[]')

  hasContacts: ( ->
    checkedContent = @get('checkedContent')

    return unless checkedContent.get('length')

    checkedContent.some (item) ->
      item instanceof Radium.Contact
  ).property('checkedContent.[]')

  changeFilter: (filter) ->
    @set('currentPage', 1)
    @set 'model.selectedFilter', filter

  showMembers: (resource) ->
    @set('currentPage', 1)
    Ember.run =>
      @set('model.selectedResource', resource)
      @trigger 'selectedResourceChanged', resource
      @set 'model.selectedFilter', 'resource'

    Ember.run.next =>
      @set('model.selectedResource', null)

  displayLeads: (leads) ->
    @get('controllers.pipelineLeads').set('filteredLeads', leads)
    @transitionToRoute 'pipeline.leads'

  displayOpenDeals: (deals) ->
    @get('controllers.pipelineOpendeals').set('filteredDeals', deals)
    @transitionToRoute 'pipeline.opendeals'
