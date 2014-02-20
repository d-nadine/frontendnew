Radium.MentionFieldView = Ember.View.extend
  classNameBindings: ['disabled:is-disabled', ':mention-field-view']
  sourceBinding: 'controller.controllers.users'

  reset: ->
    @$('.mentions-input-box div.mentions').html('')

  template: Ember.Handlebars.compile """
    {{view view.textArea}}
  """
  getAvatar: (item) ->
    unless item.get('avatar')
      return "/images/default_avatars/small.png"

    """
      <img src="#{item.avatar}" title="#{item.name}" class="avatar avatar-small">
    """

  search: (mode, query, callback) ->
    data = @get('source').filter( (item) =>
      item.get('name').toLowerCase().indexOf(query.toLowerCase()) > -1
    ).map( (item) =>
      id: item.get('id'), name: item.get('name'), avatar: @getAvatar(item), type: 'user'
    ).toArray()

    callback.call(this, data)

  textArea: Ember.TextArea.extend
    rows: 1
    tabIndexBinding: 'parentView.tabIndex'
    placeholderBinding: 'parentView.placeholder'
    disabledBinding: 'parentView.disabled'
    valueBinding: 'parentView.value'

    keyDown: (event) ->
      if event.keyCode is 13
        event.preventDefault()

    insertNewline: (event) ->
      @get('parentView.controller').send 'submit'

    didInsertElement: ->
      @_super.apply this, arguments
      @$().mentionsInput
        onDataRequest: @get('parentView').search.bind(@get('parentView'))
