Radium.ShowMoreEmailsView = Em.View.extend
  templateName: 'radium/inbox/showmore_emails'
  isVisibleBinding: 'controller.remainingContent.length'
