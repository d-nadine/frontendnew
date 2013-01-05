Radium.InboxSidebarController = Em.ArrayController.extend
  content: Ember.A()
  active: null

  setActive: (email) ->
    @set('active', @get('firstObject'))
    @set('firstObject.isActive', true)
