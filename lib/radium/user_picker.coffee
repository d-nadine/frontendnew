Radium.UserPicker = Ember.View.extend
  classNameBindings: [
    'user:is-valid'
    'isInvalid'
    'disabled:is-disabled'
    ':control-box'
    ':datepicker-control-box'
  ]

  disabled: Ember.computed.alias('controller.isDisabled')
  userBinding: 'controller.user'
  nameBinding: 'nameToUserTransform'

  isSubmitted: Ember.computed.alias('controller.isSubmitted')
  isInvalid: (->
    Ember.isEmpty(@get('value')) && @get('isSubmitted')
  ).property('value', 'isSubmitted')

  nameToUserTransform: ((key, value) ->
    if arguments.length == 2
      result = Radium.User.all().find (user) =>
        user.get('name') is value
      @set 'user', result
    else if !value && @get('user')
      @get 'user.name'
    else
      value
  ).property()

  template: Ember.Handlebars.compile """
    <span class="text">
      Assigned To
    </span>

    {{view view.textField}}

    {{#unless view.disabled}}
      <div class="btn-group">
        <button class="btn dropdown-toggle" data-toggle="dropdown">
          <i class="icon-chevron-down"></i>
        </button>
        <ul class="dropdown-menu">
          {{#each users}}
            <li><a {{action setName this.name target=view href=true}}>{{name}}</a></li>
          {{/each}}
        </ul>
      </div>
    {{/unless}}
  """

  setName: (name) ->
    @set 'name', name

  textField: Ember.TextField.extend
    valueBinding: 'parentView.name'
    disabledBinding: 'parentView.disabled'

    didInsertElement: ->
      @$().typeahead source: @source

    # FIXME: make this async
    source: (query, process) ->
      Radium.User.all().map((c) -> c.get('name')).toArray()
