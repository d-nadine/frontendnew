Radium.ResourceLinkComponent = Ember.Component.extend
  tagName: 'span'
  isUser: ( ->
    return false unless @get('content')
    @get('content').constructor is Radium.User
  ).property('content')

  isContact: ( ->
    return false unless @get('content')
    @get('content').constructor is Radium.Contact
  ).property('content')

  isCompany: ( ->
    return false unless @get('content')
    @get('content').constructor is Radium.Company
  ).property('content')

  isTag: ( ->
    return false unless @get('content')
    @get('content').constructor is Radium.Tag
  ).property('content')

  isDeal: ( ->
    return false unless @get('content')
    @get('content').constructor is Radium.Deal
  ).property('content')

  isAttachment: ( ->
    return false unless @get('content')
    @get('content').constructor is Radium.Attachment
  ).property('content')

  isDiscussion: ( ->
    return false unless @get('content')
    @get('content').constructor is Radium.Discussion
  ).property('content')

  isMeeting: ( ->
    return false unless @get('content')
    @get('content').constructor is Radium.Meeting
  ).property('content')

  isEmail: ( ->
    return false unless @get('content')
    @get('content').constructor is Radium.Email
  ).property('content')

  content: ( ->
    if @get('model') instanceof Ember.ObjectController
      @get('model.content')
    else
      @get('model')
  ).property('model')
