Radium.MeetingAttendeesView = Radium.View.extend
  isEditable: Ember.computed.not 'controller.isNew'
  actions:
    showContextMenu: (attendee) ->
      return false unless @get('isEditable')

      el = @$()

      dropdown = el.find('.contextMenu')

      dropdown.toggleClass('open')

      event.stopPropagation()

  tagName: 'li'
  attributeBindings: ['controller.displayName:title']

  template: Ember.Handlebars.compile """
      {{#if isLoaded}}
        {{avatar this style="medium"}}
        <span class="invitee-name">{{displayName}}</span>
        {{#unless isInvited}}
          <a href="#" class="btn-close" {{action removeSelection this}}>&times;</a>
        {{else}}
          <a href="#" class="btn-close" {{action showContextMenu this target="view"}}>&times;</a>
        {{/unless}}
      {{else}}
        {{partial 'is_loading'}}
      {{/if}}
      <div class="contextMenu dropdown">
        <a class="dropdown-toggle needsclick" href="#">
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
