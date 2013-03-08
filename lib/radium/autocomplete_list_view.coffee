Radium.AutocompleteView = Ember.View.extend
  classNameBindings: [
    'isInvalid'
    'hasUsers:is-valid'
    ':field'
    ':autocomplete'
  ]

  isSubmitted: Ember.computed.alias('controller.isSubmitted')
  users: Ember.computed.alias('controller.users')
  source: Ember.computed.alias('controller.source')
  template: Ember.Handlebars.compile """
    <ul class="as-selections">
    {{#each source}}
      <li {{action showContextMenu this target="view"}} {{bindAttr class="controller.isEditable :as-selection-item :blur"}}>
        {{#unless controller.isEditable}}
        <a class="as-close" {{action removeSelection this}}>×</a>
        {{/unless}}
        {{avatar this}}
        {{#if name}}
          {{name}}
        {{else}}
          {{email}}
        {{/if}}
      </li>
    {{/each}}
      <li class="as-original">
        {{view view.autocomplete}}
      </li>
    </ul>
    <div class="attendeeDropdown" class="dropdown">
      <a class="dropdown-toggle" data-toggle="dropdown" href="#">
        link<b class="caret"></b>
      </a>
      <div class="attendeeMenu dropdown-menu">
        <table>
          <tr>
            <td><a href="#">Remove Attendee</a></td>
            <td><a href="#">Resend Invite</a></td>
          </tr>
        </table>
      </div>
    </div>
  """
  showContextMenu: (attendee) ->
    return false unless @get('controller.isEditable')

    el = $(event.srcElement)

    position = el.position()

    dropdown = el.parents('div.autocomplete:eq(0)').find('.attendeeDropdown')

    dropdown.css
      position: "absolute",
      left: position.left  + "px"
      top: position.top + el.height() + 7 + "px"

    dropdown.find('a:eq(0)').trigger('click.dropdown.data-api')

    event.stopPropagation()

  didInsertElement: ->
    @get('controller').addSelection @get('controller.currentUser') if @get('controller.isNew')

  autocomplete: Ember.TextField.extend
    currentUser: Ember.computed.alias 'controller.currentUser'
    didInsertElement: ->
      @$().autoSuggest {retrieve: @retrieve.bind(this)},
                        selectedItemProp: "name"
                        searchObjProps: "name"
                        formatList: @formatList.bind(this)
                        getAvatar: @getAvatar.bind(this)
                        selectionAdded: @selectionAdded.bind(this)
                        resultsHighlight: true
                        canGenerateNewSelections: true
                        retrieveLimit: 5

    selectionAdded: (item) ->
      # FIXME create new contact while meeting is being saved
      if typeof item == "string"
        item = Ember.Object.create
                  email: item

      @get('controller').addSelection item

    formatList: (data, elem) ->
      email= data.data.get('email')

      name = if data.name && email
                "#{data.name} (#{email})"
             else if data.name
                data.name
             else
               email

      content = """
        #{@getAvatar(data)}
        #{name}
      """
      elem.html(content)

    retrieve: (query, callback) ->
      people = @get('controller.people')

      return unless people.get('length')

      results = people.filter( (item) =>
                        @get('controller.source').indexOf(item) == -1
                     ).map (item) =>
                        @mapSearchResult.call this, item

      callback(results, query)

    mapSearchResult: (result) ->
      currentUser = @get('currentUser')

      name = if result.constructor == Radium.User && result.get('id') == currentUser.get('id')
                "#{result.get('name')} (Me)"
             else
                result.get('name') || result.get('email')

      result =
        value: "#{result.constructor}-#{result.get('id')}"
        name: name
        # FIXME: Get real avatar
        avatar: "/images/default_avatars/small.png"
        data: result

    getAvatar: (data) ->
      unless data.data
        data.avatar = "/images/default_avatars/small.png"
      """
        <img src="#{data.avatar}" title="#{data.name}" class="avatar avatar-small">
      """
