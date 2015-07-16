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

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    Ember.run.scheduleOnce 'afterRender', this, 'addListeners'

  addListeners: ->
    p "foo"
