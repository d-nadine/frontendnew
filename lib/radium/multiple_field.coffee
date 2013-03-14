Radium.MultipleField = Ember.View.extend
  open: false

  didInsertElement: ->
    @set 'current', @get('source.firstObject')

  template: Ember.Handlebars.compile """
    <label class="control-label">Phone Number</label>
    <div class="controls">
      {{view Ember.TextField classNames="field" valueBinding="view.current.value" placeholder="Phone Number"}}
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
    </div>
  """

  selectValue: (object) ->
    @set('current', object)

  toggleDropdown: ->
    @toggleProperty 'open'
