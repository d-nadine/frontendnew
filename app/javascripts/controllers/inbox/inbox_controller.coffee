Radium.InboxController = Em.ArrayController.extend
  contentBinding: 'inboxSidebarController'
  selectedMail: ( ->
    @filter (email) -> email.get('isSelected')
  ).property('@each.isSelected')


