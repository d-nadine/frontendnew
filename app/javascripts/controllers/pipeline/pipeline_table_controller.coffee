Radium.PipelineTableController = Em.ArrayController.extend Radium.PaginationMixin, Radium.CheckableMixin,
  contentBinding: 'pipelineController'
  perPage: 7

  deleteAll: ->
    # FIXME: ember-data errors, fake for now
    # @get('checkedContent').forEach (contact) ->
    #   contact.deleteRecord()

    # @get('store').commit()
    @get('checkedContent').setEach('isChecked', false)

    Radium.Utils.notify 'Leads deleted'

  deleteLead: (event) ->
    lead = event.context
    # FIXME: ember-data errors, fake for now
    # lead.deleteRecord()
    # @get('store').commit()

    lead.set 'isChecked', false
    Radium.Utils.notify "lead deleted."

