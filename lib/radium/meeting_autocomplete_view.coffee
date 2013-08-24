Radium.MeetingAutocompleteView = Radium.AsyncAutocompleteView.extend
  template: Ember.Handlebars.compile """
    <div class="contextMenu" class="dropdown">
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
  filterResults: (item) ->
    !@get('source').contains(item.get('person'))


