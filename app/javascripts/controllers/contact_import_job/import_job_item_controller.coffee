Radium.ImportJobsItemController = Radium.ObjectController.extend
  actions:
    toggleErrors: ->
      @toggleProperty 'showErrors'
      false

  showErrors: false
  completedWithErrors: Ember.computed 'importStatus', 'importErrors.[]', ->
    return false if ['initialized', 'started', 'processing', 'deleting'].contains @get('importStatus')

    @get('importErrors.length')

  linkText: Ember.computed 'showErrors', ->
    if @get('showErrors') then 'Hide' else 'show'
