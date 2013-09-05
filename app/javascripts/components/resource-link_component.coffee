Radium.ResourceLinkComponent = Ember.Component.extend
  isUser: ( ->
    @get('model').constructor is Radium.User
  ).property('model')

  isContact: ( ->
    @get('model').constructor is Radium.Contact
  ).property('model')

  isCompany: ( ->
    @get('model').constructor is Radium.Company
  ).property('model')

  isTag: ( ->
    @get('model').constructor is Radium.Tag
  ).property('model')

  isDeal: ( ->
    @get('model').constructor is Radium.Deal
  ).property('model')

  isAttachment: ( ->
    @get('model').constructor is Radium.Attachment
  ).property('model')

  isDiscussion: ( ->
    @get('model').constructor is Radium.Discussion
  ).property('model')

  isMeeting: ( ->
    @get('model').constructor is Radium.Meeting
  ).property('model')

  isEmail: ( ->
    @get('model').constructor is Radium.Meeting
  ).property('model')
