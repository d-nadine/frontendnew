Radium.LeadsImportController= Ember.ObjectController.extend
  importing: false
  percentage: 0
  showInstructions: false

  fileUploaded: (->
    if @get('importing')
      progresser = setInterval(=>
        if @get("percentage") < 100
          @incrementProperty "percentage"
        else
          clearInterval(progresser)
          @transitionTo "leads.match"
      , 100)
  ).observes('importing').on('init')

  actions:
    importFile: (event) ->
      @set "importing", true
      return

    toggleInstructions: ->
      @toggleProperty "showInstructions"
      return