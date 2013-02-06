require 'models/mixins/next_task_mixin'

Radium.Contact = Radium.Model.extend Radium.FollowableMixin, Radium.NextTaskMixin,
  name: DS.attr('string')
  email: DS.attr('string')
  phone: DS.attr('string')
  status: DS.attr('string')
  source: DS.attr('string')

  avatar: DS.attr('object')

  todos: DS.hasMany('Radium.Todo')
  meetings: DS.hasMany('Radium.Meeting')
  deals: DS.hasMany('Radium.Deal')

  user: DS.belongsTo('Radium.User')

  isExpired: Radium.computed.daysOld('createdAt', 60)

  latestDeal: ( ->
    # FIXME: Is it safe to assume that
    #deals will be ordered on the server?
    @get('deals.firstObject')
  ).property('deals')
