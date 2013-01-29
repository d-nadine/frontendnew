Radium.FoldersController = Em.ArrayController.extend
  content: [
    Em.Object.create({label: 'Inbox', name: 'inbox'})
    Em.Object.create({label: 'Sent items', name: 'sent'})
    Em.Object.create({label: 'Attachments', name: 'attachments'})
    Em.Object.create({label: 'Meeting Invitations', name: 'meetings'})
    Em.Object.create({label: 'Clients', name: 'clients'})
    Em.Object.create({label: 'Opportunities', name: 'opportunities'})
    Em.Object.create({label: 'Leads', name: 'leads'})
    Em.Object.create({label: 'Prospects', name: 'prospects'})
  ]
