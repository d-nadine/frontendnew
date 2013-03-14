require 'forms/discussion_form'

Radium.DevelopmentDiscussionFormController = Ember.Controller.extend Radium.CurrentUserMixin,
  needs: ['users']
  discussion: Radium.computed.newForm('discussion')

  discussionFormDefaults: (->
    content: {}
  ).property()

  justAddedDiscussion: (->
    Ember.ObjectProxy.create
      content: Radium.DiscussionForm.create
        content: Ember.Object.create
          text: "Big long text"
      justAdded: true
  ).property()
