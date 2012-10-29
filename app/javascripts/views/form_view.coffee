Radium.FormView = Ember.View.extend
  tagName: 'form'
  classNames: 'well form-horizontal radium-form'.w()
  layoutName: 'radium/layouts/form'

  isValid: false

  init: ->
    @_super.apply(this, arguments)
    @set 'showOptions', false

  keyUp: (event) ->
    @close()  if event.keyCode is 27

  # Standalone view close. If using form in a ContainerView, override.
  # See Radium.InlineForm mixin.
  close: (event) ->
    self = this
    @$().slideUp 'fast', ->
      $(this).remove()
      self.destroy()

    false

  submit: (event) ->
    event.preventDefault()
    @submitForm()
    false


  # Show/hide the extra options when creating a todo.
  toggleOptions: ->
    @toggleProperty 'showOptions'
    false

  toggleOptionsText: (->
    (if (@get('showOptions')) then 'Less options' else 'More options')
  ).property('showOptions').cacheable()

  submitButton: Ember.View.extend(Ember.TargetActionSupport,
    tagName: 'button'

    attributeBindings: ['type', 'disabled']
    type: 'submit'
    isValidBinding: 'parentView.isValid'
    template: Ember.Handlebars.compile('<i class=\'icon-inline-loading\'></i> <span>Save</span>')
    disabled: (->
      !@get('isValid')
    ).property('isValid')
  )
  cancelFormButton: Ember.View.extend(Ember.TargetActionSupport,
    tagName: 'a'
    attributeBindings: ['href', 'title']
    href: '#'
    title: 'Close form'
    target: 'this'
    action: 'close'
  )

  submitForm: ->
    if @close
      @close()
    else
      @get('parentView').close this
