Radium.MessagesController = Em.ArrayController.extend
  content: [
    Em.Object.create({label: 'Inbox', name: 'inbox'})
    Em.Object.create({label: 'Sent items', name: 'sent'})
    Em.Object.create({label: 'Attachments', name: 'attachments'})
    Em.Object.create({label: 'Meetings', name: 'meetings'})
    Em.Object.create({label: 'Clients', name: 'clients'})
    Em.Object.create({label: 'Opportunities', name: 'opportunities'})
    Em.Object.create({label: 'Leads', name: 'leads'})
    Em.Object.create({label: 'Prospects', name: 'prospects'})
  ]

  init: ->
    @set('firstObject.selected', true)

  showMessage: (event) ->
    event.stopPropagation()

    @every (item) -> item.set('selected', false)

    folder = event.context
    folder.set('selected', true)

    @get('sidebarEmailToolbarController').setFolder(folder)
