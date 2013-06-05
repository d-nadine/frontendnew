require 'forms/form'
Radium.DiscussionForm = Radium.Form.extend
  data: ( ->
    user: @get('user')
    topic: @get('topic')
  ).property().volatile()

  isValid: ( ->
    not Ember.isEmpty(@get('topic'))
  ).property('topic','justAdded')

  reset: ->
    @_super.apply this, arguments
    @set 'topic', ''

  commit: ->
    discussion = Radium.Discussion.createRecord @get('data')

    # FIXME: hack to set referene
    discussion.set('_referenceContact', Radium.Contact.find().get('firstObject'))

    @get('store').commit()
