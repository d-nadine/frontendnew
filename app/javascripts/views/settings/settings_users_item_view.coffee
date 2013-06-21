Radium.SettingsUsersItemView = Ember.View.extend
  tagName: 'li'
  templateName: 'settings/users_item'

  didInsertElement: ->
    @get('content.model').on('resendInvite', =>
      @flashResentInviteMessage()
    )

  willDestroyElement: ->
    @get('content.model').off('resendInvite')

  flashResentInviteMessage: ->
    @set('resentInvite', true)
    Ember.run.later(=>
      @$('.invite-resent').show().delay(1000).fadeOut(=>
        @set('resentInvite', false)
      )
    , 1500)
