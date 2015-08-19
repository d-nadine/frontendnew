Radium.ListstatusesEditorComponent = Ember.Component.extend
  actions:
    createNewStatus: ->
      name = @get('newStatus.name') || ''

      unless name.length
        @$().find('.new-list-status-name').focus()
        return @flashMessenger.error "you must supply a name."

      statusType = if @get('newStatus.isActive')
                     "active"
                   else
                     "inactive"

      record = Radium.ListStatus.createRecord
                  name: name
                  statusType: statusType
                  list: @get('list')

      record.save().then =>
        @flashMessenger.success "List Status Created"
        @send "closeListStatusModal"

      false

    addNewListStatus: ->
      @set "newStatus", Ember.Object.create
                          name: null
                          isActive: true

      @set "showListStatusModal", true

      Ember.run.next =>
        return unless el = @$()

        el.find('.new-list-status-name').focus()

      false

    closeListStatusModal: ->
      @set "newStatus", null

      @set "showListStatusModal", false

      false

  newStatus: null
  tagName: 'ul'
  classNames: ['span5']
  newStatusNameValidations: ['required']
  errorMessages: []
