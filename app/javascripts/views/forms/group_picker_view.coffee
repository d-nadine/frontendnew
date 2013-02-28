Radium.FormsGroupPickerView = Ember.View.extend
  classNameBindings: [
    'disabled:is-disabled'
    ':control-box'
    ':datepicker-control-box'
  ]

  disabled: Ember.computed.alias('controller.isDisabled')
  gropuBinding: 'controller.group'
  nameBinding: 'nameToGroupTransform'

  isSubmitted: Ember.computed.alias('controller.isSubmitted')
  isInvalid: (->
    Ember.isEmpty(@get('value')) && @get('isSubmitted')
  ).property('value', 'isSubmitted')

  nameToGroupTransform: ((key, value) ->
    if arguments.length == 2
      result = Radium.Group.all().find (group) =>
        group.get('name') is value
      @set 'group', result
    else if !value && @get('group')
      @get 'group.name'
    else
      value
  ).property()

  leader: "location"
  template: Ember.Handlebars.compile """
    <span class="text">{{view.leader}}</span>

    {{view view.textField}}

    {{#unless view.disabled}}
      <div class="btn-group">
        <button class="btn dropdown-toggle" data-toggle="dropdown">
          <i class="icon-chevron-down"></i>
        </button>
        <ul class="dropdown-menu">
          {{#each group}}
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
      Radium.Group.all().map((c) -> c.get('name')).toArray()
