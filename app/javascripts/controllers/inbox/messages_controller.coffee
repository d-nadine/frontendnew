Radium.MessagesController = Em.ArrayController.extend
  content: [
    Em.Object.create({label: 'Inbox', name: 'inbox'})
    Em.Object.create({label: 'Sent items', name: 'sent'})
    Em.Object.create({label: 'Attachments', name: 'attachments'})
    Em.Object.create({label: 'Meeting Invitations', name: 'meetings'})
  ]

  init: ->
    @set('firstObject.selected', true)

  showMessage: (event) ->
    event.stopPropagation()

    @every (item) -> item.set('selected', false)

    folder = event.context
    folder.set('selected', true)

    Radium.get('router').send('showMessage', folder.name)
