Radium.InboxSidebarController = Em.ArrayController.extend
  sortProperties: ['sentAt']

  content: Ember.A()
  active: null

  activeDidChange: ( ->
    email = @get('active')

    # return if email.get('read')

    email.set('read', true)

    @get('store').commit()
  ).observes('active')

  setActive: (email) ->
    @set('active', @get('firstObject'))
    @set('firstObject.isActive', true)
