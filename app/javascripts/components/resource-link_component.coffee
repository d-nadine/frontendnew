Radium.ResourceLinkComponent = Ember.Component.extend
  tagName: 'span'
  isUser: ( ->
    @get('content').constructor is Radium.User
  ).property('content')

  isContact: ( ->
    @get('content').constructor is Radium.Contact
  ).property('content')

  isCompany: ( ->
    @get('content').constructor is Radium.Company
  ).property('content')

  isTag: ( ->
    @get('content').constructor is Radium.Tag
  ).property('content')

  isDeal: ( ->
    @get('content').constructor is Radium.Deal
  ).property('content')

  isAttachment: ( ->
    @get('content').constructor is Radium.Attachment
  ).property('content')

  isDiscussion: ( ->
    @get('content').constructor is Radium.Discussion
  ).property('content')

  isMeeting: ( ->
    @get('content').constructor is Radium.Meeting
  ).property('content')

  isEmail: ( ->
    @get('content').constructor is Radium.Email
  ).property('content')

  content: ( ->
    if @get('model') instanceof Ember.ObjectController
      @get('model.content')
    else
      @get('model')
  ).property('model')
