Radium.DevelopmentWidgetsController = Ember.Controller.extend
  needs: ['users']

  date: Ember.DateTime.create()

  user: null

  todo: (->
    Factory.create 'todo'
  ).property()

  call: (->
    Factory.create 'call'
  ).property()

  meeting: (->
    Factory.create 'meeting'
  ).property()

  tasks: (->
    [@get('todo'), @get('call'), @get('meeting')]
  ).property()
