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

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @$('.who').tooltip()

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

    el = @$('.who')

    if el.data('tooltip')
      el.tooltip('destroy')
