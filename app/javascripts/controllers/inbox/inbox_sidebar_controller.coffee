Radium.InboxSidebarController = Em.ArrayController.extend
  sortProperties: ['sentAt']

  content: Ember.A()
  active: null

  activeDidChange: ( ->
    email = @get('active')

    email.set('read', true)

    @get('store').commit()
  ).observes('active')

  setActive: (email) ->
    @set('active', @get('firstObject'))
    @set('firstObject.isActive', true)

  deleteEmail: (event) ->
    email = event.context

    Radium.get('router.inboxController').deleteEmail(email)
