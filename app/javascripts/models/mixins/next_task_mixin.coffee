Radium.NextTaskMixin = Ember.Mixin.create
  nextTask: DS.attr('object')
  latestTask: ( ->
    nextTask = @get('nextTask')
    return null unless nextTask

    nextTask.get("description") || nextTask.get("topic")
  ).property('nextTask')

