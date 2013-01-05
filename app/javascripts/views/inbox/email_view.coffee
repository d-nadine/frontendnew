Radium.EmailView = Em.View.extend
  templateName: 'radium/inbox/email'
  classNames: 'email fadeIn'.w()
  didInsertElement: ->
    active = $('ul.messages li.active')
    return if active.length == 0

    setTimeout(( ->
      $('div.arrow').css(top: active.offset().top - 35))
      , 200)
  willDestroyElement: ->
    @$().removeClass('fadeIn').addClass('fadeOut')

