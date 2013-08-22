Radium.MessagesController = Radium.ArrayController.extend Radium.CheckableMixin, Radium.SelectableMixin,
  needs: ['application']
  sortProperties: ['time']
  sortAscending: false
  applicationController: Ember.computed.alias 'controllers.application'

  folderBinding: 'model.folder'

  folders: [
    { title: 'Inbox', name: 'inbox' }
    { title: 'Sent items', name: 'sent' }
    { title: 'Discussions', name: 'discussions' }
    { title: 'All Emails', name: 'emails' }
  ]

  selectionsDidChange: (->
    if @get('content').filterProperty('isChecked').get('length')
      @transitionTo 'messages.bulk_actions'
    else if @get('applicationController.currentPath') == 'messages.bulk_actions'
      @send 'back'
  ).observes('content.@each.isChecked')

  canSelectItems: (->
    @get('checkedContent.length') == 0
  ).property('checkedContent.length')

  noSelection: (->
    return false if @get('selectedContent')
    return false if @get('hasCheckedContent')
    true
  ).property('hasCheckedContent', 'selectedContent')

  clear: ->
    @get('content').clear()

  load: ->
    @get('content').load()

  selectedSearchScope: "Search All Emails"
