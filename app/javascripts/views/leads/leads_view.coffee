Radium.LeadsView = Ember.View.extend
  layoutName: 'layouts/single_column'
  existingContactChecker: Ember.TextField.extend
    classNames: ['field']
    placeholder: 'Type a name'
    keyUp: (evt) ->
      return if [40,38,9,13,27,16].indexOf(evt.keyCode) != -1
      evt.stopPropagation()
      evt.preventDefault()
