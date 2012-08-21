Radium.CommentView = Ember.View.extend
  tagName: 'li'
  didInsertElement: ->
    @$('small.time').timeago()
  templateName: 'comment'
