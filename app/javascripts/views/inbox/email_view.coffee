Radium.EmailView = Em.View.extend
  templateName: 'radium/inbox/email'
  classNames: 'email fadeIn'.w()
  willDestroyElement: ->
    @$().removeClass('fadeIn').addClass('fadeOut')

