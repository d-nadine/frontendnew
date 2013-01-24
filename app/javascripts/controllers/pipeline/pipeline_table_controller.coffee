Radium.PipelineTableController = Em.ArrayController.extend Radium.ShowMoreMixin, Radium.CheckableMixin,
  contentBinding: 'pipelineController.content'
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

