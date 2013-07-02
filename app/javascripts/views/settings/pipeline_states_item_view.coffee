Radium.PipelineStatesItemView = Ember.View.extend
  classNames: ["row", "pipeline-state-item"]
  templateName: 'settings/pipeline_states_item'

  didInsertElement: ->
    if @get('content.isNew')
      @$().addClass('new')
      @$()[0].offsetWidth
      @$().addClass('out')
      @$('.inline-field').focus()