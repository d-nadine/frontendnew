Radium.FormBoxController = Radium.ObjectController.extend Ember.Evented,
  Radium.SaveTemplateMixin,
  actions:
    showForm: (form) ->
      @get("#{form}Form").reset()
      @set 'activeForm', form
      if @get('showMeetingForm')
        @set 'meetingForm.isExpanded', true

      Ember.run.later this, =>
        @trigger 'focusTopic'
      , 400

    submitForm: ->
      activeForm = @get("#{@get('activeForm')}Form")
      @EventBus.publish "#{@activeForm}:formSubmitted"
      @trigger 'focusTopic'

    saveEmail: (form) ->
      @get('parentController').send "saveEmail", form

      false

  activeForm: 'todo'

  showTodoForm: Ember.computed.equal('activeForm', 'todo')
  showNoteForm: Ember.computed.equal('activeForm', 'note')
  showMeetingForm: Ember.computed.equal('activeForm', 'meeting')
  showEmailForm: Ember.computed.equal('activeForm', 'email')

  needs: ['userSettings']

  settings: Ember.computed.alias 'controllers.userSettings.model'
  signature: Ember.computed.alias 'settings.signature'

  template: null

  onFormChanged: (form) ->
    return unless form

    formName = "#{form}Form"

    observer = =>
      return unless @get(formName)

      @removeObserver 'activeForm', observer

      @send 'showForm', form

    if @get(formName)
      observer()
    else
      @addObserver 'activeForm', this

  setup: Ember.on 'init', ->
    unless parentController = @get('parentController')
      return

    return unless parentController?.on

    parentController.on('formChanged', this, 'onFormChanged')
