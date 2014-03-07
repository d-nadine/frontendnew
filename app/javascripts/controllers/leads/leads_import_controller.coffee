Radium.LeadsImportController= Ember.ObjectController.extend
  actions:
    importFile: (event) ->
      @set "importing", true
      return

    toggleInstructions: ->
      @toggleProperty "showInstructions"
      return

    cancelImport: (rowCount) ->
      @set 'rowCount', rowCount
      @set 'showLargeImportMessage', true
      @set 'showInstructions', false
      false

    dismissLargeImportMessage: ->
      @set 'rowCount', 0
      @set 'showLargeImportMessage', false
      @set 'showInstructions', false
      false

  importing: false
  percentage: 0
  showInstructions: false
  showLargeImportMessage: false
  rowCount: 0
  disableImport: false

  fileUploaded: (->
    if @get('importing')
      progresser = setInterval(=>
        if @get("percentage") < 100
          @incrementProperty "percentage"
        else
          clearInterval(progresser)
          @setProperties(
            importing: false
            percentage: 0
          )
      , 100)
  ).observes('importing').on('init')
