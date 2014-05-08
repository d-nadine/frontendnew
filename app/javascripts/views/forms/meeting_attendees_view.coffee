Radium.MeetingAttendeesView = Radium.View.extend
  actions:
    showContextMenu: ->
      return false unless @get('isEditable')

      el = @$()

      dropdown = el.find('.contextMenu')

      dropdown.toggleClass('open')

      dropdown.css
        position: 'absolute',
        top: @$('img').height()

      event.preventDefault()
      event.stopPropagation()

  isEditable: Ember.computed.not 'controller.parentController.isNew'
  isOrganizer: Ember.computed.alias 'controller.isOrganizer'
  tagName: 'li'
  attributeBindings: ['controller.title:title']

  didInsertElement: ->
    @_super.apply this, arguments

    $('body').on 'click.attendees-view', (e) =>
      @$().find('.contextMenu').removeClass('open')

    # @$().tooltip()

  willDestroyElement: ->
    @_super.apply this, arguments
    $('body').off 'click.attendees-view'
    if @$()?.data('tooltip')
      @$().tooltip('destroy')

  click: (e) ->
    dropdown = @$().find('.contextMenu')[0]

    @$().parent().find('.contextMenu').each (index, el)  =>
      $(el).removeClass('open') unless el == dropdown

    return false if @get('isOrganizer')
    return false unless @get('isEditable')
    @send 'showContextMenu', @get('controller.model')

  template: Ember.Handlebars.compile """
    <div class="media">
      <div class="invitee-thumb pull-left">
        {{#if isLoaded}}
          {{avatar this style="large" class="media-object"}}
          {{#if displayStatus}}
            <span {{bind-attr class=":invitation-status invitationStatus"}}>{{invitationStatus}}</span>
          {{/if}}
        {{else}}
          {{partial 'is_loading'}}
        {{/if}}
      </div>
      <div class="media-body">
        <div class="media-heading">
          {{resource-link-to this}}
        </div>
        <div class="media-content">
          {{#if isOrganizer}}
            <span class="label">Organizer</span>
          {{else}}
            <div class="invitee-actions">
              {{#if isInvited}}
              <div class="btn-group">
                <a href="#" class="btn btn-mini btn-danger" {{action "cancelInvitation" this}}>Remove Attendee</a></td>
              </div>
              <div class="btn-group">
                <a href="#" class="btn btn-mini btn-success" {{action "resendInvite" this}}>Resend Invite</a></td>
              </div>
              {{else}}
                <a href="#" class="btn btn-mini" {{action "removeSelection" this}}>
                  <i class="ss-symbolicons-block ss-trash"></i>
                </a>
              {{/if}}
            </div>
          {{/if}}
        </div>
      </div>
    </div>
    """
