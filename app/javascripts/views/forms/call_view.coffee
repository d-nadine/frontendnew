require 'views/forms/todo_view'
require 'lib/radium/combobox'

Radium.FormsCallView = Radium.FormsTodoView.extend
  todoField: Radium.FormsTodoFieldView.extend
    placeholder: 'about...'

  contactPicker: Radium.Combobox.extend
    sourceBinding: 'controller.contacts'
    valueBinding: 'controller.reference'
    placeholder: 'Choose a contact to call...'
    disabledBinding: 'controller.isPrimaryInputDisabled'

  callBox: Ember.View.extend
    contactBinding: 'controller.reference'
    classNames: ['btn-group', 'call-control-box']
    dropDownTabIndex: (->
      return unless @get('tabIndex')
      @get('tabIndex') + 1
    ).property('tabIndex')

    click: (event) ->
      event.preventDefault()
      event.stopPropagation()

    template: Ember.Handlebars.compile """
      <button class="btn btn-success" {{bindAttr tabIndex="view.tabIndex"}}>
        <i class="icons-call-white"></i>
      </button>
      <button class="btn btn-success dropdown-toggle" data-toggle="dropdown" {{bindAttr tabindex="view.dropDownTabIndex"}}>
        <span class="caret"></span>
      </button>
      <ul class="dropdown-menu">
        <li><a href="#">138213947834</a></li>
        <li><a href="#">329841932847</a></li>
        <li><a href="#">132948738873</a></li>
        <li><a href="#">Other Number</a></li>
      </ul>
    """

  submit: ->
    return unless @get('controller.isValid')
    @get('controller').submit()
    @get('controller').reset()
