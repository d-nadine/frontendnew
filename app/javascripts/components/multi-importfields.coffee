Radium.MultiImportfieldsComponent = Ember.Component.extend
  actions:
    addNew: ->
      @sendAction 'addNew'

    removeField:  (field) ->
      @sendAction 'removeField', field

  classNames: ['control-group']
