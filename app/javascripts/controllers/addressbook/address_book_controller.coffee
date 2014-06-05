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

      addTagsForm.set 'controller', this

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
  needs: ['contacts']
  contacts: Ember.computed.alias 'controllers.contacts'

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
    # {name: 'all', text: 'Show All'}
    {name: 'people', text: 'People'}
    {name: 'companies', text: 'Companies'}
    {name: 'tags', text: 'Tags'}
    # {name: 'private', text: 'Private Contacts', isPrivate: true}
  ]

  filters: [
    {name: 'assigned', text: 'Assigned To Me'}
    {name: 'lead', text: 'Lead'}
    {name: 'exclude', text: 'Excluded from Pipeline'}
  ]

  additionalFilterDisabled: Ember.computed 'model.additionalFilter', 'model.selectedFilter', ->
    return true if @get('isCompanies')
    selectedFilter = @get('model.selectedFilter') 
    if selectedFilter == 'private'
      @set 'model.additionalFilter', null
      return true

  isPrivateContacts: Ember.computed 'model.selectedFilter', ->
    @get('model.selectedFilter') == 'private'

  isCompanies: Ember.computed 'model.selectedFilter', ->
    @get('model.selectedFilter') == 'companies'

  isTags: Ember.computed 'model.selectedFilter', ->
    @get('model.selectedFilter') == 'tags'

  showEmptyAddressBookButton: Ember.computed 'isPrivateContacts', 'content.[]', 'filter', ->
    return false if @get('isPrivateContacts')
    filter = @get('model.selectedFilter')

    return false if filter == 'companies' || filter == 'tags'

    not @get('content.content')
      .filter((item) -> 
        item.constructor is Radium.Contact && not item.get('isPersonal'))?.length

  assignableContent: Ember.computed 'checkedContent.[]', ->
    checkedContent = @get('checkedContent')

    return unless checkedContent.get('length')

    checkedContent.some (item) ->
      item instanceof Radium.Contact || item instanceof Radium.Company

  showAddTags: Ember.computed.equal('activeForm', 'addTags')

  addTagsForm: Radium.computed.newForm('addTags')

  addTagsFormDefaults: Ember.computed 'checkedContent.[]', ->
    tagNames: Ember.A()
    selectedContent: @get('checkedContent')

  hasContacts: Ember.computed 'checkedContent.[]', ->
    return false if @get('isPrivateContacts')

    checkedContent = @get('checkedContent')

    return unless checkedContent.get('length')

    checkedContent.some (item) ->
      item instanceof Radium.Contact

  changeFilter: (filter) ->
    @set('currentPage', 1)
    if ['companies', 'tags', 'people'].indexOf(filter) != -1
      if filter == 'people'
        @transitionToRoute 'addressbook.contacts'
        return

      @transitionToRoute "addressbook.#{filter}"
      return

    @set 'model.selectedFilter', filter
