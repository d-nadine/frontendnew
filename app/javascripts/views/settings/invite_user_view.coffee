Radium.InviteUserView = Ember.View.extend
  templateName: 'settings/invite_user'
  didInviteUser: Ember.observer 'controller.didInvite', ->
    if @get('controller.didInvite')
      Ember.run.later(=>
        $.when(@$('.help-inline').fadeOut()).then(=>
          @get('controller').reset()
        )
      , 1500)

  didInsertElement: ->
    @_super.apply this, arguments
    @get('controller').send 'reset'
