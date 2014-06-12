Radium.EmailsThreadController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  perPage: 5
  sortedReplies: Ember.computed.sort 'visibleContent', (left, right) ->
    a = left.get('sentAt') || left.get('updatedAt')
    b = right.get('sentAt') || right.get('updatedAt')
    Ember.DateTime.compare b, a
