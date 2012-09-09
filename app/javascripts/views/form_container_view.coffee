Radium.FormContainerView = Ember.ContainerView.extend
  controllerBinding: 'Radium.router.formController'

  elementId: 'form-container'
  isVisible: (->
    !!@get('currentView')
  ).property('currentView')

  showForm: (type) ->
    this["show#{type.camelize().capitalize()}Form"]()
    $('#form-container').ScrollTo(offsetTop: 100, duration: 200)

  close: (event) ->
    self = this
    form = @get('currentView')
    form.set 'isGlobalLevelForm', false
    form.$().slideUp 'fast', ->
      self.set 'currentView', null
      form.destroy()

    false

  show: (form) ->
    form.set 'isGlobalLevelForm', true
    @set 'currentView', form

  showMeetingForm: () ->
    form = Radium.MeetingFormView.create()
    form.set 'controller', Radium.MeetingFormController.create()
    @show form

  showTodoForm: () ->
    @show Radium.TodoFormView.create()

  showOrHide: (->
    if type = @get('controller.type')
      @showForm(type)
    else
      @close()
  ).observes('controller.type')
