Radium.InviteUserView = Ember.View.extend
  templateName: 'settings/invite_user'
  didInviteUser: (->
    if @get('controller.didInvite')
      Ember.run.later(=>
        $.when(@$('.help-inline').fadeOut()).then(=>
          @get('controller').reset()
        )
      , 1500)
  ).observes('controller.didInvite')
