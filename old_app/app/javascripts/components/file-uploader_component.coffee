require 'mixins/views/uploading_mixin'

Radium.FileUploaderComponent = Ember.Component.extend Radium.UploadingMixin,
  attributeBindings: ['href']
  tagName: 'a'
  href: "#"

  change: (e) ->
    files = e.target.files
    return if Ember.isEmpty(files)

    @uploadFiles files

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @addClickHandler()

  handleClick: (e) ->
    @$('input[type=file]').trigger 'click'

    @addClickHandler()

  addClickHandler: ->
    Ember.run.next =>
      return unless el = @$()
      el.one 'click', Ember.run.bind(this, @handleClick)
