Radium.UploadFileComponent = Ember.Component.extend
  action:
    removeFile: (file) ->
      @sendAction 'removeFile', file

      false

  classNameBindings: [':item']

  progressIndicator: 0

  fakeProgressWidth: Ember.computed 'progressIndicator', ->
    "width: #{@get('progressIndicator')}%"

  _setup: Ember.on 'didInsertElement', ->
    return if @get('file.isLoaded')

    @progress()

  _teardown: Ember.on 'willDestroyElement', ->
    if progressTick = @get('progressTick')
      Ember.run.cancel progressTick

  progress: ->
    if @get('file.isLoaded')
      return Ember.run.cancel @get('progressTick')

    progressTick = Ember.run.later this, =>
      nextProgress = @get('progressIndicator') + 3

      if nextProgress >= 100
        nextProgress = 0

      Ember.run.next =>
        @set 'progressIndicator', nextProgress

      @progress()
    , 300

    @set "progressTick", progressTick
