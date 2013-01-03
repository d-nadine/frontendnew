Radium.EmailView = Em.View.extend
  templateName: 'radium/inbox/email'
  classNames: 'flipInX'.w()
  willDestroyElement: ->
    @$().removeClass('fadeIn').addClass('fadeOut')

