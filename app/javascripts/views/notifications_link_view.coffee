Radium.NotificationsLinkView = Em.View.extend
  classNames: ['notifications-link']
  template: Em.Handlebars.compile('{{view.count}}')
  tagName: 'a'

  countBinding: 'controller.count'
  controllerBinding: 'Radium.router.notificationsController'

  click: ->
    @get('controller').toggleNotifications()
