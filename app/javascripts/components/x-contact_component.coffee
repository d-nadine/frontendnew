Radium.XContactComponent = Ember.Component.extend
  actions:
    addTag: (tag) ->
      @sendAction "addTag", @get('contact'), tag

      false

    removeTag: (tag) ->
      @sendAction "removeTag", @get('contact'), tag

      false

    confirmDeletion: ->
      @sendAction "confirmDeletion"

      false

  classNames: ['two-column-layout']