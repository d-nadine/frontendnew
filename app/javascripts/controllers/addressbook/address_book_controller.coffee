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
    {name: 'assigned', text: 'Assigned To Me'}
    {name: 'lead', text: 'Lead'}
    {name: 'exclude', text: 'Excluded from Pipeline'}
    {name: 'personal', text: 'Personal Contacts'}
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
    if ['companies', 'tags', 'people'].indexOf(filter) != -1
      if filter == 'people'
        @transitionToRoute 'addressbook.contacts'
        return

      @transitionToRoute "addressbook.#{filter}"
      return

    @set 'model.selectedFilter', filter

  addTags: ->
    addTagsForm = @get('addTagsForm')
    addTagsForm.addTags()

    @get('store').commit()
    addTagsForm.reset()

    @set 'activeForm', null
    Radium.Utils.notify "Selected tags added"

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
