Radium.MeetingAutocompleteView = Radium.AsyncAutocompleteView.extend
  actions:
    addSelection: (item) ->
      @get('controller').send('addSelection', item)
    removeSelection: (item) ->
      @get('controller').send('removeSelection', item)

  sourceBinding: 'controller.participants'
  currentUserEmail: Ember.computed.alias 'controller.currentUser.email'

  queryParameters: (query) ->
    term: query
    email_only: true
    scopes: ['user', 'contact']

  template: Ember.Handlebars.compile """
    <div class="contextMenu" class="dropdown">
      <a class="dropdown-toggle needsclick" data-toggle="dropdown" href="#">
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
  filterResults: (item) ->
    item.get('email') != @get('parentView.currentUserEmail') &&
    !@get('source').map((selection) => selection.get('email')).contains(item.get('email'))
