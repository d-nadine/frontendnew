require 'forms/change_status'
require 'forms/reassign_form'
require 'controllers/pipeline/pipeline_item_controller'
require 'mixins/controllers/bulk_action_controller_mixin'

Radium.PipelineBaseController = Radium.ArrayController.extend Radium.ShowMoreMixin, 
  Radium.CheckableMixin,
  Radium.BulkActionControllerMixin,

  isLeads: ( ->
    @get('title') == 'Leads'
  ).property('title')
