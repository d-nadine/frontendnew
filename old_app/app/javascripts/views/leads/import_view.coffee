Radium.LeadsImportView = Radium.View.extend
  _tearDown: Ember.on 'willDestroyElement', ->
    if progressTick = @get('controller.progressTick')
      Ember.run.cancel progressTick
