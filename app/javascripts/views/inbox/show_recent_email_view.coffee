Radium.ShowRecentEmailView = Ember.View.extend
  templateName: 'radium/inbox/show_recent_email'
  isVisibleBinding: 'controller.hasPreviousEmails'

