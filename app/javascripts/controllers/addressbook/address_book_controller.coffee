require 'lib/radium/show_more_mixin'
require 'mixins/controllers/bulk_action_controller_mixin'

Radium.AddressbookController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  Radium.CheckableMixin,
  Radium.BulkActionControllerMixin,
  Ember.Evented,

  actions:
    additionalFilter: (additional) ->
      @set('model.additionalFilter', additional)

    addTags: ->
      addTagsForm = @get('addTagsForm')
      addTagsForm.addTags()

      @get('store').commit()
      addTagsForm.reset()

      @set 'activeForm', null

      @send 'flashSuccess', 'Selected tags added'

    addTag: (tag) ->
      tagNames = @get('addTagsForm.tagNames')

      return if tagNames.contains tag

      tagNames.addObject Ember.Object.create name: tag

    displayLeads: (leads) ->
      @get('controllers.pipelineLeads').set('filteredLeads', leads)
      @transitionToRoute 'pipeline.leads'

    displayOpenDeals: (deals) ->
      @get('controllers.pipelineOpendeals').set('filteredDeals', deals)
      @transitionToRoute 'pipeline.opendeals'

    setupNewCompany: ->
      @trigger 'setupNewCompany'

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

  categories: [
    {name: 'all', text: 'Show All'}
    {name: 'people', text: 'People'}
    {name: 'companies', text: 'Companies'}
    {name: 'tags', text: 'Groups'}
    {name: 'private', text: 'Private Contacts', isPrivate: true}
  ]

  filters: [
    {name: 'assigned', text: 'Assigned To Me'}
    {name: 'lead', text: 'Lead'}
    {name: 'exclude', text: 'Excluded from Pipeline'}
  ]

  additionalFilterDisabled: ( ->
    return true if @get('isCompanies')
    selectedFilter = @get('model.selectedFilter') 
    if selectedFilter == 'private'
      @set 'model.additionalFilter', null
      return true
  ).property('model.additionalFilter', 'model.selectedFilter')

  isPrivateContacts: ( ->
    @get('model.selectedFilter') == 'private'
  ).property('model.selectedFilter')

  isCompanies: ( ->
    @get('model.selectedFilter') == 'companies'
  ).property('model.selectedFilter')

  showEmptyAddressBookButton: ( -> 
    return false if @get('isPrivateContacts')
    filter = @get('model.selectedFilter')

    return false if filter == 'companies' || filter == 'tags'

    not @get('model.length')
  ).property('isPrivateContacts', 'arrangedContent.[]', 'filter')

  assignableContent: ( ->
    checkedContent = @get('checkedContent')

    return unless checkedContent.get('length')

    checkedContent.some (item) ->
      item instanceof Radium.Contact || item instanceof Radium.Company
  ).property('checkedContent.[]')

  showAddTags: Ember.computed.equal('activeForm', 'addTags')

  addTagsForm: Radium.computed.newForm('addTags')

  addTagsFormDefaults: ( ->
    tagNames: Ember.A()
    selectedContent: @get('checkedContent')
  ).property('checkedContent.[]')

  hasContacts: ( ->
    return false if @get('isPrivateContacts')

    checkedContent = @get('checkedContent')

    return unless checkedContent.get('length')

    checkedContent.some (item) ->
      item instanceof Radium.Contact
  ).property('checkedContent.[]')

  changeFilter: (filter) ->
    @set('currentPage', 1)
    if ['companies', 'tags', 'people'].indexOf(filter) != -1
      if filter == 'people'
        @transitionToRoute 'addressbook.contacts'
        return

      @transitionToRoute "addressbook.#{filter}"
      return

    @set 'model.selectedFilter', filter
