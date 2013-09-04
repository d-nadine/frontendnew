Radium.AuthManager = Ember.Object.extend
  _token: null
  init: ->
    @_super.apply this, arguments
    @set('token', $.cookie('token'))

  token: ((key, value) ->
    if arguments.length == 2
      @set '_token', value
      return

    @get('_token')
  ).property('_token').volatile()

  setAjaxHeaders: ( ->
    if token = @get('_token')
      $.ajaxSetup
        headers:
          "X-Ember-Compat": "true",
          "X-User-Token": token
  ).observes('_token')

  tokenDidChange: ( ->
    token = @get('_token')

    return unless Ember.isEmpty(token)

    location.replace('http://api.radiumcrm.com/sessions/new')
  ).observes('token')

  logOut: (apiUrl) ->
    Ember.$.ajax
      url: "#{apiUrl}/sessions/destroy"
      dataType: 'jsonp',
      success:  ->
        location.replace 'http://www.radiumapp.com/'
