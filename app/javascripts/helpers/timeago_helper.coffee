# http://localhost:8080/calendar/meetings/1014
Radium.TimeAgoView = Ember.View.extend
  template: Ember.Handlebars.compile """
    {{view.formattedContent}}
  """

  didInsertElement: ->
    @_super.apply this, arguments
    @tick()

  formattedContent: Ember.computed( ->
    fromNow = (date) ->

      now = Ember.DateTime.create()

      timeDiff = Math.ceil((now.get('milliseconds') - date.get('milliseconds')) / (1000 * 60))

      if timeDiff <= 1
        return "A few seconds ago"
      else if timeDiff < 60
        return "#{timeDiff} minute(s) ago"
      else
        return "#{Math.floor(timeDiff / 60)} hour(s) ago"

    fromNow @get('content')
  ).property('content')

  tick: ->
    nextTick = Ember.run.later this, =>
      @notifyPropertyChange 'formattedContent'
      @tick()
    , 60000

    @set 'nextTick', nextTick

  willDestroyElement: ->
    @_super.apply this, arguments
    Ember.run.cancel @get('nextTick')

Ember.Handlebars.registerHelper 'timeAgo', (property, options) ->
  value = Ember.get(this, property) || Ember.DateTime.create()

  options.hash.content = value

  Ember.Handlebars.helpers.view.call(this, Radium.TimeAgoView, options)
