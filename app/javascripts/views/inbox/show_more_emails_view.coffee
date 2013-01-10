Radium.ShowMoreEmailsView = Em.View.extend
  templateName: 'radium/inbox/show_more_emails'
  isVisibleBinding: 'controller.hasRemainingItems'
