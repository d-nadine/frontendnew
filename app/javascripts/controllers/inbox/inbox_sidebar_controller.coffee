Radium.InboxSidebarController = Em.ArrayController.extend
  sortProperties: ['sentAt']
  contentBinding: 'inboxController'
  selectedEmailBinding: 'inboxController.selectedEmail'

  selectEmail: (event) ->
    email = event.context
    @set 'selectedEmail', email
