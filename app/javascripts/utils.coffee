Radium.Utils =

notify: (message, options) ->
    defaults =
      type: 'alert-success'
      delay: 3000

    settings = $.extend({}, defaults, options)

    notification = $("""
            <div id="alerts" class="offset1">
              <div class="alert #{settings.type}">
                <button type="button" class="close" data-dismiss="alert">×</button>
                #{message}
              </div>
            </div>
            """)

    $('body').append(notification)

    notification.fadeIn('fast', ( ->
      setTimeout(( ->
        notification.fadeOut('fast', ->
          $('#alerts').remove()
        )
      ), settings.delay)
    ))

  notifyError: (message) ->
    @notify message,
              type: 'alert-error'
              delay: 8000

  generateErrorSummary: (object) ->
    return "" if object.get('errors').length == 0

    html = ""

    errors = for name, error of object.get('errors')
                                  "#{name} #{error}"

    for error in errors
      html += "#{error}<br/>"

    @notify html,
              type: 'alert-error'
              delay: 2000

