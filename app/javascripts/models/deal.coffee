require 'models/mixins/next_task_mixin'

Radium.Deal = DS.Model.extend Radium.CommentsMixin, Radium.FollowableMixin, Radium.AttachmentsMixin, Radium.NextTaskMixin,
  name: DS.attr('string')
  description: DS.attr('string')
  payBy: DS.attr('datetime')
  value: DS.attr('number')
  reason: DS.attr('string')

  # Can be `published`, `negotiating`, `closed`, `paymentpending`
  status: DS.attr('string')

  todos: DS.hasMany('Radium.Todo', inverse: 'deal')
  meetings: DS.hasMany('Radium.Meeting')

  contact: DS.belongsTo('Radium.Contact')
  user: DS.belongsTo('Radium.User')

  isPastPayment: Radium.computed.isPast("payBy")
