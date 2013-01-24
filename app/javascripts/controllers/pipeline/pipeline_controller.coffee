Radium.PipelineController = Em.ArrayController.extend Radium.PaginationMixin, Radium.CheckableMixin,
  statusesBinding: 'pipelineStatusController.statuses'
  content: ( ->
    status = @get('pipelineStatusController.status')
    return unless status
    Radium.Contact.find(statusFor: status)
  ).property('pipelineStatusController.status')
  perPage: 7

  deleteAll: ->
    # FIXME: ember-data errors, fake for now
    # @get('checkedContent').forEach (contact) ->
    #   contact.deleteRecord()

    # @get('store').commit()
    @get('content').setEach('isChecked', false)

    Radium.Utils.notify 'Leads deleted'

  deleteLead: (event) ->
    lead = event.context
    # FIXME: ember-data errors, fake for now
    # lead.deleteRecord()
    # @get('store').commit()

    lead.set 'isChecked', false
    Radium.Utils.notify "lead deleted."

