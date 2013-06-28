Radium.PipelineStatesItemView = Ember.View.extend
  classNames: ["row", "pipeline-state-item"]
  templateName: 'settings/pipeline_states_item'

  didInsertElement: ->
    @$('.inline-field').focus() if @get('content.isNew')