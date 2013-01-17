Radium.Utils =
  notify: (message, options) ->
    defaults =
      type: 'success'

    settings = $.extend({}, defaults, options)

    notification = $("""
            <div class="alert alert-success">
              <button type="button" class="close" data-dismiss="alert">×</button>
              #{message}
            </div>
            """)

    if !settings.ele
      settings.ele = $("<div id='alerts'></div>")
      $('#main-panel > div > div').prepend(settings.ele)

    settings.ele.append(notification)

    setTimeout(( ->
      notification.fadeOut('slow', ->
        notification.remove() if notification
      )
    ), 1000)

