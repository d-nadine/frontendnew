Radium.NotificationsLinkView = Em.View.extend
  classNames: ['notifications-link']
  template: Em.Handlebars.compile('{{view.count}}')
  tagName: 'a'

  controllerBinding: 'Radium.router.notificationsController'
  countBinding: 'controller.count'

  click: ->
    @get('controller').toggleNotifications()
