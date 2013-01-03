Radium.InboxSidebarController = Em.ArrayController.extend
  content: Ember.A()
  active: null

  contentDidLoad: ( ->
    return unless @get('content.isLoaded') || @get('content.length') == 0 || @get('active')

    @set('active', @get('firstObject'))
    @set('firstObject.isActive', true)
  ).observes('content.isLoaded')

