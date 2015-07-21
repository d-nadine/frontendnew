Radium.TextExpanderComponent = Ember.Component.extend
  actions:
    expand: ->
      @set 'current', @get('current') + @step

      false

  current: 0
  step: 10
  hasMore: false

  truncatedText: Ember.computed 'text', 'current', ->
    text = @get('text') || ''

    return unless text.length

    parts = text.split /\<br\/\>/g

    next = @current + @step

    if next >= parts.length
      @set 'hasMore', false
      return parts.join('<br/>')

    @set 'hasMore', true

    parts.slice(0, next).join('<br/>')
