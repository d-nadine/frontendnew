Radium.FormsPickerView = Ember.View.extend
  classNameBindings: [
    'disabled:is-disabled'
    ':control-box'
    ':datepicker-control-box'
  ]

  disabled: Ember.computed.alias('controller.isDisabled')
  isSubmitted: Ember.computed.alias('controller.isSubmitted')

  template: Ember.Handlebars.compile """
    <span class="text">{{view.leader}}</span>

    {{view view.textField}}

    {{#unless view.disabled}}
      <div class="btn-group">
        <button class="btn dropdown-toggle" data-toggle="dropdown">
          <i class="icon-chevron-down"></i>
        </button>
        <ul class="dropdown-menu">
          {{#each view.list}}
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
      @$().typeahead source: @get('parentView').source
