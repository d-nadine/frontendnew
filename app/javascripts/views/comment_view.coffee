Radium.CommentView = Ember.View.extend
  classNames: ['comment']
  tagName: 'li'
  didInsertElement: ->
    @$('small.time').timeago()
  templateName: 'radium/comment'
