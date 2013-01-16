Radium.Utils =
  notify: (message, options) ->
    defaults =
      ele: $('#alert-area')
      type: 'success'

    settings = $.extend({}, defaults, options)

    notification = $("""
            <div class="alert alert-success">
              <button type="button" class="close" data-dismiss="alert">×</button>
              #{message}
            </div>
            """)
    settings.ele.append(notification)

    setTimeout(( ->
      notification.fadeOut('slow', -> notfication.remove())
    ), 1000)

