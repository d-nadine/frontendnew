require 'forms/form'
Radium.DiscussionForm = Radium.Form.extend
  data: ( ->
    text: @get('text')
  ).property().volatile()

  isValid: ( ->
    not Ember.isEmpty(@get('text'))
  ).property('text','justAdded')

  commit: ->
    discussion = Radium.Discussion.createRecord @get('data')

    discussion.store.commit()
