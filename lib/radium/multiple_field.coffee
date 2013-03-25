require 'lib/radium/radio'

Radium.MultipleFields = Ember.ContainerView.extend
  currentIndex: -1
  didInsertElement: ->
    @_super.apply this, arguments
    @addNew()

  addNew: ->
    @set('currentIndex', @get('currentIndex') + 1)
    @pushObject(Radium.MultipleField.create
      classNameBindings: [':control-group']
      source: @get('source')
      leader: @get('leader')
      type: @get('type')
      index: @get('currentIndex')
    )

Radium.MultipleField = Ember.View.extend
  classNames: ['multiple-field']
  open: false

  didInsertElement: ->
    @set 'current', @get('source').objectAt(@get('index'))
    @set('current.value', "") unless @get('current.value')

    @set('showDropDown', @get('index') != 0)

  addNew: ->
    @get('parentView').addNew()
    @set 'showDropDown', true

  showAddNew: ( ->
    return false if @get('showDropDown')
    return false if @get('index') == (@get('source.length') - 1)

    @get('current.value.length') > 1
  ).property('current.value', 'showDropDown')

  label: ( ->
    "#{@get('current.name')} #{@get('leader')}"
  ).property('leader', 'current.name')

  layout: Ember.Handlebars.compile """
    <label class="control-label">{{view.label}}</label>
    <div class="controls" {{!bindAttr class="view.isInvalid:is-invalid"}}>
      {{yield}}
    </div>
    {{#if view.showAddNew}}
      <div>
        <a href="#" {{action addNew target="view" bubbles="false"}}>add new</a>
      </div>
    {{/if}}
    {{#if view.showDropDown}}
      <div class="controls selector">
        <div class="btn-group mutiple-field" {{bindAttr class="view.open:open"}}>
          <button class="btn" {{action toggleDropdown target="view" bubbles="false"}}>
            {{view.current.name}}
          </button>
          <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
            <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            {{#each view.source}}
              <li><a {{action selectValue this target="view"}}href="#">{{unbound name}}</a></li>
            {{/each}}
          </ul>
        </div>
        {{view view.primaryRadio}}
      </div>
    {{/if}}
  """


  template: Ember.Handlebars.compile """
    {{view Ember.TextField typeBinding="view.type" classNames="field input-xlarge" valueBinding="view.current.value" placeholderBinding="view.leader"}}
  """

  primaryRadio: Radium.Radiobutton.extend
    leader: 'Make Primary'

    isChecked: Ember.computed.bool 'parentView.current.isPrimary'

    click: (evt) ->
      evt.stopPropagation()
      @get('parentView.source').setEach('isPrimary', false)
      @set('parentView.current.isPrimary', true)

  selectValue: (object) ->
    @set('current', object)

  toggleDropdown: ->
    @toggleProperty 'open'
