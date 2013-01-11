Radium.Utils =
  notify: (message, options) ->
    defaults =
      ele: $('#alert-area')
      type: 'success'

    settings = $.extend({}, defaults, options)

    settings.ele.notify(
      message: { text: message }
      type: settings.type
    ).show()
