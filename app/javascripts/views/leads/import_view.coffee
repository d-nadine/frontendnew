Radium.LeadsImportView = Radium.View.extend
  tags: Radium.TagAutoComplete.extend
    placeholder: 'Add tags for each contact'
    sourceBinding: 'controller.tagNames'

  _tearDown: Ember.on 'willDestroyElement', ->
    if progressTick = @get('controller.progressTick')
      Ember.run.cancel progressTick
