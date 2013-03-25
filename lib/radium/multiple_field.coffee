require 'lib/radium/radio'

Radium.MultipleFields = Ember.ContainerView.extend
  currentIndex: -1
  didInsertElement: ->
    @_super.apply this, arguments
    @set('source.firstObject.isPrimary', true) if @get('source.length')
    @addNew()

  removeSelection: (view) ->
    view.set('current.value', null)

    currentViewIsPrimary = view.get('current.isPrimary')

    view.set('current.isPrimary', false)

    @get('source').removeObject(view.get('current'))
    @get('source').pushObject(view.get('current'))

    @removeObject view

    newIndex = 0

    @get('childViews').forEach (childView) ->
      childView.set('index', newIndex)
      newIndex += 1

      if currentViewIsPrimary
        childView.set('current.isPrimary', true)
        currentViewIsPrimary = false

    @set('currentIndex', @get('currentIndex') - 1)

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

  showDelete: ( ->
    @get('parentView.childViews.length') > 1
  ).property('parentView.childViews.[]')

  showAddNew: ( ->
    index = @get('index')
    sourceLength = (@get('source.length') - 1)
    return false if index == sourceLength
    return false if @get('parentView.currentIndex') == sourceLength

    @get('current.value.length') > 1
  ).property('current.value', 'showDropDown', 'parentView.currentIndex')

  label: ( ->
    "#{@get('current.name')} #{@get('leader')}"
  ).property('leader', 'current.name')

  removeSelection: ->
    @get('parentView').removeSelection this

  layout: Ember.Handlebars.compile """
    <label class="control-label">{{view.label}}</label>
    <div class="controls" {{!bindAttr class="view.isInvalid:is-invalid"}}>
      {{yield}}
    </div>
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
        {{#if view.showDelete}}
          <a href="#">
            <i {{action removeSelection target="view" bubbles="false"}} class="icon-trash"></i>
          </a>
        {{/if}}
      </div>
    {{/if}}
    {{#if view.showAddNew}}
      <div>
        <a href="#" {{action addNew target="view" bubbles="false"}}>add new</a>
      </div>
    {{/if}}

  """

  template: Ember.Handlebars.compile """
    {{view Ember.TextField typeBinding="view.type" classNames="field input-xlarge" valueBinding="view.current.value" placeholderBinding="view.leader"}}
  """

  primaryRadio: Radium.Radiobutton.extend
    leader: 'Make Primary'

    didInsertElement: ->
      @set('checked', true) if @get('parentView.current.isPrimary')

    isChecked: Ember.computed.bool 'parentView.current.isPrimary'

    click: (evt) ->
      evt.stopPropagation()
      @get('parentView.source').setEach('isPrimary', false)
      @set('parentView.current.isPrimary', true)

  selectValue: (object) ->
    @set('current', object)

  toggleDropdown: ->
    @toggleProperty 'open'
