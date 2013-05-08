require 'forms/change_status'
require 'forms/reassign_form'
require 'controllers/pipeline/pipeline_item_controller'
require 'controllers/pipeline/pipeline_controller_mixin'

Radium.PipelineBaseController = Radium.ArrayController.extend Radium.ShowMoreMixin, 
  Radium.CheckableMixin,
  Radium.PipelineControllerMixin,

  isLeads: ( ->
    @get('title') == 'Leads'
  ).property('title')
