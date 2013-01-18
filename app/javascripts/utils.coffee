Radium.Utils =
  notify: (message, options) ->
    defaults =
      type: 'success'

    settings = $.extend({}, defaults, options)

    notification = $("""
            <div id="alerts" class="span8">
              <div class="alert alert-success">
                <button type="button" class="close" data-dismiss="alert">×</button>
                #{message}
              </div>
            </div>
            """)

    $('#main-panel > div > div').append(notification)

    notification.fadeIn('fast', ( ->
      setTimeout(( ->
        notification.fadeOut('slow', ->
          notification.remove() if notification
        )
      ), 1000)
    ))

