Radium.PipelineChecklistItemView = Ember.View.extend
  classNames: 'controls-row pipeline-checklist-item',
  classNameBindings: ['content.isEditing', 'controller.isNewItem']
  templateName: 'settings/pipeline_checklist_item'