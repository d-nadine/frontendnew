require 'forms/form'
Radium.DiscussionForm = Radium.Form.extend
  data: ( ->
    user: @get('user')
    topic: @get('topic')
    reference: @get('reference')
  ).property().volatile()

  isValid: ( ->
    not Ember.isEmpty(@get('topic'))
  ).property('topic','justAdded')

  reset: ->
    @_super.apply this, arguments
    @set 'topic', ''
    @set('submitForm', false)

  commit: ->
    discussion = Radium.Discussion.createRecord @get('data')

    @get('store').commit()
