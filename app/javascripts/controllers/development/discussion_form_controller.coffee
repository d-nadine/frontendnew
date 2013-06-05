require 'forms/discussion_form'

Radium.DevelopmentDiscussionFormController = Ember.Controller.extend Radium.CurrentUserMixin,
  needs: ['users']
  discussion: Radium.computed.newForm('discussion')

  discussionFormDefaults: (->
    user: @get('currentUser')
    topic: ''
  ).property()

  justAddedDiscussion: (->
    Ember.ObjectProxy.create
      content: Radium.DiscussionForm.create
        content: Ember.Object.create
          topic: "Big long text"
      justAdded: true
  ).property()
