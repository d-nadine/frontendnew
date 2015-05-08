Radium.UserTotalComponent = Ember.Component.extend
  actions:
    showUserRecords: ->
      @sendAction "action", @get('user'), @get('query')

      false

  classNameBindings: [':item', 'isCurrent:active']

  user: Ember.computed 'userTotal.id', ->
    Radium.User.all().find (u) => u.get('id') == @get('userTotal.id').toString()

  isCurrent: Ember.computed 'parent.conversationType', 'user.id', ->
    parent = @get('parent')
    parent.get('conversationType') == @get('query') && parent.get('user') == @get('user.id')
