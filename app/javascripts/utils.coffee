Radium.Utils =
  notify: (message, options) ->
    defaults =
      type: 'success'

    settings = $.extend({}, defaults, options)

    notification = $("""
            <div id="alerts" class="span12">
              <div class="alert alert-success">
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
      ), 3000)
    ))
